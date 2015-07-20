class User < ActiveRecord::Base
  has_one :account,   dependent: :destroy
  has_many :tasks,     dependent: :destroy
  has_many :offerings, dependent: :destroy
  has_many :wants,     dependent: :destroy
  has_many :entries,   dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :entrusts, dependent: :destroy

  has_many :sended_messages,   class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recepient_id'
  has_many :senders,    through: :received_messages, source: :sender
  has_many :recepients, through: :sended_messages,   source: :recepient

  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower # source:は省略可

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates :name, presence: true

  attr_accessor :account_id

  scope :active, -> { where.not(confirmed_at: nil) }

  def talks(companion = nil)
    if companion.present?
      messages = Talk.where('sender_id = :id and recepient_id = :companion_id or sender_id = :companion_id and recepient_id = :id', id: id, companion_id: companion.id)
    else
      messages = Talk.where('sender_id = :id or recepient_id = :id', id: id)
    end
    messages
  end

  def companions
    sql =  "SELECT DISTINCT * FROM ("
    sql += "SELECT users.*, messages.created_at AS messages_created_at FROM users INNER JOIN messages ON users.id = messages.sender_id WHERE messages.type = 'Talk' AND messages.recepient_id = :id"
    sql += " UNION "
    sql += "SELECT users.*, messages.created_at AS messages_created_at FROM users INNER JOIN messages ON users.id = messages.recepient_id WHERE messages.type = 'Talk' AND messages.sender_id = :id"
    sql += ") AS companions ORDER BY messages_created_at DESC"
    companions = User.find_by_sql([sql, { id: id }])
    companions
  end

  def entried?(task)
    entries.find_by(task_id: task.id)
  end

  def entry!(task)
    entries.create!(task_id: task.id)
  end

  def unentry!(task)
    entries.find_by(task_id: task.id).destroy
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
end
