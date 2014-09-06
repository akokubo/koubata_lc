class User < ActiveRecord::Base
  has_many :tasks
  has_many :offerings
  has_many :wants
  has_many :passings
  has_many :messages,   through: :passings
  has_many :companions, through: :passings
  has_one  :account

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates :name, presence: true
end
