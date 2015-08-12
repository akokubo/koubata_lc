json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :body, :url, :read_at
  json.url notification_url(notification, format: :json)
end
