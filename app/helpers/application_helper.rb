module ApplicationHelper
  # ページごとの完全なタイトルを返す
  def full_title(page_title)
    base_title = '幸畑プロジェクト'
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def resource_name
    :user
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_user?(user)
    current_user == user
  end

  def home_page?
    controller.controller_name == 'home' && controller.action_name == 'index'
  end

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    class_options = options[:class]
    if class_options
      image_tag(gravatar_url, alt: user.name, class: class_options)
    else
      image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
  end
end
