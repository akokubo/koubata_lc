class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_device

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
end
