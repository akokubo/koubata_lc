class HomeController < ApplicationController
  def index
  end

  def need_help
  end

  def about
  end

  def contact
  end

  def status
    @notifications_count = Notification.where("user_id = :current_user_id AND read_at IS NULL", current_user_id:  current_user.id).count
  end

  def watch_list
  end

  def new_display
  end

  def detailed
  end
end
