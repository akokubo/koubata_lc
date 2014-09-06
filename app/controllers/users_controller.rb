class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where("id != '#{current_user.id}'")
  end

  def show
    @user = User.find(params[:id])
  end

  def messages
    @user = User.find(params[:id])
    @passings = @user.passings.where(companion_id: current_user.id)
    @message = Message.new
    @message.recepient_id = @user.id
    @message.sender_id = current_user.id
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
