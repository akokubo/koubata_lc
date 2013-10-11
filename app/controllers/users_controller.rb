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
    @user = User.find(params[:id])
    @offerings = @user.offerings
  end

  def wants
    @user = User.find(params[:id])
    @wants = @user.wants
  end

end
