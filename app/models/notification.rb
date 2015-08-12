class Notification < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :body, presence: true
  validates :url,  presence: true

  self.per_page = 10

  def read?
    if read_at.nil?
      false
    else
      true
    end
  end

  def read!
    self.update!(read_at: Time.now)
  end

  def unread!
    self.update!(read_at: nil)
  end
end
