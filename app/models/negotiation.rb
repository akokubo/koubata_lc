class Negotiation < Message
  after_save :notify

  private

  def notify
    notification = Notification.find_by(user: recepient, url: entry.url)
    if notification.nil?
      Notification.create!(
        user: recepient,
        body: "#{sender.name}さんからの相談があります。",
        url:  entry.url
      )
    else
      notification.update!(
        body: "#{sender.name}さんからの相談があります。",
        read_at: nil
      )
    end
  end
end
