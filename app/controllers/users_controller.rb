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
    @messages = current_user.messages(@user).order('created_at DESC')
    @message = Message.new
    @message.recepient_id = @user.id
    @message.sender_id = current_user.id
  end

  def offerings
    @class_name = Offering
    @user = User.find(params[:id])
    @tasks = @user.offerings
    render 'tasks'
  end

  def wants
    @class_name = Want
    @user = User.find(params[:id])
    @tasks = @user.wants
    render 'tasks'
  end

  def following
    @title = "follows"
    @no_user = "No followed user"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "is followed by"
    @no_user = "No follower"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
end
