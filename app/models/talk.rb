class Talk < Message
  after_save :notify

  private

  def notify
    url = Rails.application.routes.url_helpers.talks_user_path(sender)

    notification = Notification.find_by(user: recepient, url: url)
    if notification.nil?
      Notification.create!(
        user: recepient,
        body: "#{sender.name}さんからのメッセージがあります。",
        url:  url
      )
    else
      notification.update!(read_at: nil)
    end
  end
end
