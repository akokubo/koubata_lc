class User < ActiveRecord::Base
  has_many :offerings
  has_many :wants
  has_many :messages, foreign_key: "from_id", dependent: :destroy
  has_one :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  validates :name, presence: true
end
