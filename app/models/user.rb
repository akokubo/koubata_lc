class User < ActiveRecord::Base
  has_one :account,    dependent: :destroy
  def account_id
    account.id
  end
  has_many :tasks,     dependent: :destroy
  has_many :offerings, dependent: :destroy
  has_many :wants,     dependent: :destroy
  has_many :entries

  has_many :sended_messages,   class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recepient_id'
  has_many :senders,    through: :received_messages, source: :sender
  has_many :recepients, through: :sended_messages,   source: :recepient

  has_many :relationships,         foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :followed_users, through: :relationships,         source: :followed
  has_many :followers,      through: :reverse_relationships, source: :follower # source:は省略可

  has_many :notifications, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates :name, presence: true

  scope :active, -> { where.not(confirmed_at: nil).where(deleted_at: nil) }

  #
  # Talk関係メソッド
  #
  def talks(companion = nil)
    if companion.present?
      messages = Talk.between(self, companion)
      #messages = Talk.where('sender_id = :id and recepient_id = :companion_id or sender_id = :companion_id and recepient_id = :id', id: id, companion_id: companion.id)
    else
      messages = Talk.with(self)
      #messages = Talk.where('sender_id = :id or recepient_id = :id', id: id)
    end
    messages
  end

  def companions
    sql =  'SELECT DISTINCT * FROM ('
    sql += 'SELECT users.*, messages.created_at AS messages_created_at FROM users'
    sql += " INNER JOIN messages ON users.id = messages.sender_id WHERE messages.type = 'Talk' AND messages.recepient_id = :id"
    sql += ' UNION '
    sql += 'SELECT users.*, messages.created_at AS messages_created_at FROM users'
    sql += " INNER JOIN messages ON users.id = messages.recepient_id WHERE messages.type = 'Talk' AND messages.sender_id = :id"
    sql += ') AS companions ORDER BY messages_created_at DESC'
    companions = User.find_by_sql([sql, { id: id }])
    companions
  end

  #
  # Account関係メソッド
  #
  def pay_to!(recepient, args = {})
    Account.transfer(
      sender_account: self.account,
      recepient_account: recepient.account,
      amount: args[:amount],
      subject: args[:subject],
      comment: args[:commnet]
    )
    # notificationはAccountで実行
  end

  #
  # Relationship関係メソッド
  #
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
    # TODO: notificationはRelationshipで実行
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
    # TODO: notificationはRelationshipで実行
  end

  #
  # Entry関係メソッド
  #
  def entry!(entry)
    entry.save!
=begin
    if entry.task.type == 'Offering'
      entry = contracts.create!(task: entry.task, expected_at: entry.expected_at, price: entry.price)
    elsif entry.task.type == 'Want'
      entry = entrusts.create!(task: entry.task, expected_at: entry.expected_at, price: entry.price)
    end
=end
    # entry = entries.create!(task: entry.task, expected_at: entry.expected_at, price: entry.price)
    entry = commit!(entry, had_nofied: true)
    notify_entry!(entry)
    entry
  end

  def commit!(entry, args = {})
    # 状態のチェック
    unless entry.commitable?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to commit by #{id}'}"
    end

    # 引数の設定
    expected_at  = (args.key?(:expected_at) && args[:expected_at].present?) ? args[:expected_at] : entry.expected_at
    price        = (args.key?(:price) && args[:price].present?) ? args[:price] : entry.price

    if entry.owner?(self)
      entry = owner_commit!(entry, expected_at: expected_at, price: price)
    elsif entry.contractor?(self)
      entry = contractor_commit!(entry, expected_at: expected_at, price: price)
    else
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and 'user_id'=#{id} or 'task.user_id'=#{id}"
    end

    notify_commit!(entry) unless args.key?(:had_nofied) && args[:had_nofied].present?
    entry
  end

  def cancel!(entry)
    # 状態のチェック
    unless entry.cancelable?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to cancel'}"
    end

    if entry.owner == self
      entry.update!(owner_canceled_at: Time.now)
    elsif entry.contractor == self
      entry.update!(contractor_canceled_at: Time.now)
    else
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and 'user_id'=#{id} or 'task.user_id'=#{id}"
    end

    notify_cancel!(entry.reload)
    entry
  end

  def perform!(entry)
    unless entry.performable?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to perform'}"
    end

    unless entry.performer?(self)
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and user 'id'=#{id} can be able to perform"
    end

    entry.update!(performed_at: Time.now)
    notify_perform!(entry.reload)
    entry
  end

  def pay_for!(entry, args = {})
    unless entry.payable?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to pay'}"
    end

    unless entry.payer?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and user 'id'=#{id} can be able to pay"
    end

    recepient = entry.payee
    amount  = (args.key?(:amount) && args[:amount].present?) ? args[:amount] : entry.price
    subject = "#{entry.title}の支払"
    comment = args[:comment]

    payment = pay_to!(recepient, amount: amount, subject: subject, comment: comment)
    entry.update!(paid_at: Time.now, payment: payment)

    notify_pay_for!(entry.reload)
    entry
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  private

  def owner_commit!(entry, args = {})
    if !entry.conditions_change?(expected_at: args[:expected_at], price: args[:price])
      entry.update!(owner_committed_at: Time.now)
    else
      entry.update!(
        owner_committed_at: Time.now,
        contractor_committed_at: nil,
        expected_at: args[:expected_at],
        price: args[:price]
      )
    end
    entry
  end

  def contractor_commit!(entry, args = {})
    if !entry.conditions_change?(expected_at: args[:expected_at], price: args[:price])
      entry.update!(contractor_committed_at: Time.now)
    else
      entry.update!(
        owner_committed_at: nil,
        contractor_committed_at: Time.now,
        expected_at: args[:expected_at],
        price: args[:price]
      )
    end
    entry
  end

  def notify_entry!(entry)
    recepient = entry.partner_of(self)

    if entry.contractor?(self)
      body = "#{name}さんが「#{entry.title}」を引き受けました。条件を調整してください。"
    elsif entry.owner?(self)
      body = "#{name}さんが「#{entry.title}」を依頼しました。条件を調整してください。"
    end

    Notification.create!(
      user: recepient,
      body: body,
      url: entry.url
    )
  end

  def notify_commit!(entry)
    recepient = entry.partner_of(self)

    if entry.commitable?(self)
      body = "#{name}さんが「#{entry.title}」の条件を変更しました。条件を調整してください。"
    else
      body = "#{name}さんと「#{entry.title}」の契約が成立しました。"
    end

    notification = recepient.notifications.find_by(url: entry.url)
    if notification.present?
      notification.update!(user: recepient, body: body, url: entry.url, read_at: nil)
    else
      Notification.create!(user: recepient, body: body, url: entry.url)
    end
  end

  def notify_cancel!(entry)
    recepient = entry.partner_of(self)
    body = "#{name}さんが「#{entry.title}」をキャンセルしました。"

    notification = recepient.notifications.find_by(url: entry.url)
    if notification.present?
      notification.update!(user: recepient, body: body, url: entry.url, read_at: nil)
    else
      Notification.create!(user: recepient, body: body, url: entry.url)
    end
  end

  def notify_perform!(entry)
    recepient = entry.partner_of(self)
    body = "#{name}さんが「#{entry.title}」を実施しました。"
    notification = recepient.notifications.find_by(url: entry.url)
    notification.update!(user: recepient, body: body, url: entry.url, read_at: nil)
  end

  def notify_pay_for!(entry)
    recepient = entry.partner_of(self)
    body = "#{name}さんが「#{entry.title}」に支払いました。"
    notification = recepient.notifications.find_by(url: entry.url)
    notification.update!(user: recepient, body: body, url: entry.url, read_at: nil)
  end
end
