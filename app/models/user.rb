class User < ActiveRecord::Base
  has_one :account,    dependent: :destroy
  has_many :tasks,     dependent: :destroy
  has_many :offerings, dependent: :destroy
  has_many :wants,     dependent: :destroy
  has_many :entries,   dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :entrusts,  dependent: :destroy

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

  scope :active, -> { where.not(confirmed_at: nil) }

  #
  # Talk関係メソッド
  #
  def talks(companion = nil)
    if companion.present?
      messages = Talk.where('sender_id = :id and recepient_id = :companion_id or sender_id = :companion_id and recepient_id = :id', id: id, companion_id: companion.id)
    else
      messages = Talk.where('sender_id = :id or recepient_id = :id', id: id)
    end
    messages
  end

  def companions
    sql =  'SELECT DISTINCT * FROM ('
    sql += 'SELECT users.*, messages.created_at AS messages_created_at FROM users'
    sql += "INNER JOIN messages ON users.id = messages.sender_id WHERE messages.type = 'Talk' AND messages.recepient_id = :id"
    sql += ' UNION '
    sql += 'SELECT users.*, messages.created_at AS messages_created_at FROM users'
    sql += "INNER JOIN messages ON users.id = messages.recepient_id WHERE messages.type = 'Talk' AND messages.sender_id = :id"
    sql += ') AS companions ORDER BY messages_created_at DESC'
    companions = User.find_by_sql([sql, { id: id }])
    companions
  end

  #
  # Account関係メソッド
  #
  def pay_to!(recepient, args = {})
    Account.transfer(
      sender: self,
      recepient: recepient,
      amount: args[:amount],
      subject: args[:subject],
      comment: args[:commnet]
    )
  end

  #
  # Relationship関係メソッド
  #
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  #
  # Entry関係メソッド
  #
  def entry!(task, args = {})
    entry = entries.create!(task: task, expected_at: args[:expected_at], price: args[:price])
    entry = commit!(entry)
    entry
  end

  def commit!(entry, args = {})
    # 状態のチェック
    unless entry.commitable?
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and it's status be able to commit'}"
    end

    # 引数の設定
    expected_at  = (args.key?(:expected_at) && args[:expected_at].present?) ? args[:expected_at] : entry.expected_at
    price        = (args.key?(:price) && args[:price].present?) ? args[:price] : entry.price

    if entry.owner?(self)
      entry = owner_commit!(entry, expected_at: expected_at, price: price)
    elsif entry.user?(self)
      entry = user_commit!(entry, expected_at: expected_at, price: price)
    else
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and 'user_id'=#{id} or 'task.user_id'=#{id}"
    end
    entry
  end

  def cancel!(entry)
    # 状態のチェック
    unless entry.cancelable?
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to cancel'}"
    end

    if entry.owner == self
      entry.update!(owner_canceled_at: Time.now)
    elsif entry.user == self
      entry.update!(user_canceled_at: Time.now)
    else
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and 'user_id'=#{id} or 'task.user_id'=#{id}"
    end
    entry.reload
  end

  def perform!(entry)
    unless entry.performable?
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to perform'}"
    end

    unless entry.performer?(self)
      fail "Couldn't find Entry with 'id'=#{target_entry.id} and user 'id'=#{id} can be able to perform"
    end

    entry.update!(performed_at: Time.now)
    entry.reload
  end

  def pay_for!(entry, args = {})
    unless entry.payable?
      fail "Couldn't find Entry with 'id'=#{entry.id} and it's status be able to pay'}"
    end

    unless entry.payer?(self)
      fail "Couldn't find Entry with 'id'=#{entry.id} and user 'id'=#{id} can be able to pay"
    end

    recepient = entry.payee
    amount  = (args.key?(:amount) && args[:amount].present?) ? args[:amount] : entry.price
    subject = "#{entry.task.title}の支払"
    comment  = args[:comment]

    payment = pay_to!(recepient, amount: amount, subject: subject, comment: comment)
    entry.update!(paid_at: Time.now, payment: payment)

    entry.reload
  end

  private

  def owner_commit!(entry, args = {})
    if !entry.conditions_change?(expected_at: args[:expected_at], price: args[:price])
      entry.update!(owner_committed_at: Time.now)
    else
      entry.update!(
        owner_committed_at: Time.now,
        user_committed_at: nil,
        expected_at: args[:expected_at],
        price: args[:price]
      )
    end
    entry
  end

  def user_commit!(entry, args = {})
    if !entry.conditions_change?(expected_at: args[:expected_at], price: args[:price])
      entry.update!(user_committed_at: Time.now)
    else
      entry.update!(
        owner_committed_at: nil,
        user_committed_at: Time.now,
        expected_at: args[:expected_at],
        price: args[:price]
      )
    end
    entry
  end
end
