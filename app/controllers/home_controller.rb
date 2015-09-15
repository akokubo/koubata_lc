class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:status]

  def index
  end

  def need_help
  end

  def about
  end

  def contact
  end

  def status
  end

  def watch_list
  end

  def new_display
  end

  def search
  end

  def detailed
  end
end
