class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_device
  before_action :set_notifications_count, if: :user_signed_in?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # include WillPaginate::ActionView

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :description
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :description
  end

  def after_sign_out_path_for(_resource_name)
    root_path
  end

  def after_sign_in_path_for(_resource_name)
    root_path
  end

  def set_device
    if mobile_request?
      @mobile = true
    else
      @mobile = false
    end
    @mobile = false
    @mobile
  end

  def mobile_request?
    (ios_request? || android_request?)
  end

  def ios_request?
    request.user_agent =~ /(Mobile.+Safari)/
  end

  def android_request?
    request.user_agent =~ /(Android)/
  end

  def set_notifications_count
    @notifications_count = Notification.where(
      'user_id = :current_user_id AND read_at IS NULL',
      current_user_id: current_user.id
    ).count
  end
end

module WillPaginate
  module ActionView
    class JqueryMobilePaginateLinkRenderer < LinkRenderer
      def pagination
        items = [] # NOTE: ignore the :page_links option
        items.unshift :previous_page
        items.push :next_page
      end

      protected

      def html_container(html)
        tag :div, html, class: 'ui-grid-a'
      end

      def previous_or_next_page(page, text, classname)
        div_attr = {}
        link_attr = { 'data-role' => 'button' }

        link_attr[:class] = 'ui-disabled' unless page

        case classname
        when 'previous_page'
          link_attr[:'data-icon'] = 'arrow-l'
          div_attr[:class] = 'ui-block-a'
        when 'next_page'
          link_attr[:'data-icon'] = 'arrow-r'
          link_attr[:'data-iconpos'] = 'right'
          div_attr[:class] = 'ui-block-b'
        end
        tag :div, link(text, page || '#', link_attr), div_attr
      end
    end
  end
end
