class Negotiation < Message
  after_save :notify

  private

  def notify
    if entry.instance_of?(Contract)
      url = "/contracts/#{entry.id}"
    else
      url = "/entrusts/#{entry.id}"
    end

    notification = Notification.find_by(user: recepient, url: url)
    if notification.nil?
      Notification.create!(
        user: recepient,
        body: "#{sender.name}さんからの連絡があります。",
        url:  url
      )
    else
      notification.update!(
        body: "#{sender.name}さんからの連絡があります。",
        read_at: nil
      )
    end
  end
end
