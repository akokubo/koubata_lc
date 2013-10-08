class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where("id != '#{current_user.id}'")
  end

  def show
    @user = User.find(params[:id])
  end

  def messages
    with_id = params[:id]
    @with = User.find(with_id)
    @messages = Message.with(current_user.id, with_id)
    @message = Message.new
    @message.to_id = with_id
  end

  def offerings
    @offerings = Offering.where(user_id: current_user.id)
  end

  def wants
    @wants = Want.where(user_id: current_user.id)
  end

end
