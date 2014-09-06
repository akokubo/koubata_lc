class User < ActiveRecord::Base
  has_many :tasks
  has_many :offerings
  has_many :wants
  has_many :sended_messages,   class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recepient_id'
  has_many :senders,    through: :received_messages, source: :sender
  has_many :recepients, through: :sended_messages,   source: :recepient
  has_one  :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates :name, presence: true

  def messages(companion = nil)
    if companion.present?
      messages = Message.where("sender_id = :id and recepient_id = :companion_id or sender_id = :companion_id and recepient_id = :id", id: self.id, companion_id: companion.id)
    else
      messages = Message.where("sender_id = :id or recepient_id = :id", id: self.id)
    end
  end

  def companions
    sql =  'SELECT DISTINCT * FROM ('
    sql += 'SELECT "users".*, "messages"."created_at" AS "mc" FROM "users" INNER JOIN "messages" ON "users"."id" = "messages"."sender_id" WHERE "messages"."recepient_id" = :id'
    sql += ' UNION '
    sql += 'SELECT "users".*, "messages"."created_at" AS "mc" FROM "users" INNER JOIN "messages" ON "users"."id" = "messages"."recepient_id" WHERE "messages"."sender_id" = :id'
    sql += ') ORDER BY "mc" DESC'
    companions = User.find_by_sql([sql, { id: self.id }])
  end

end
