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
end
