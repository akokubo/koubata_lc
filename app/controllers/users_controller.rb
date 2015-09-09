class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id).active
  end

  def show
    @user = User.find(params[:id])
  end

  def talks
    @user = User.find(params[:id])
    @talks = current_user.talks(@user).order('created_at DESC').paginate(page: params[:page])
    @talk = Talk.new
    @talk.recepient_id = @user.id
    @talk.sender_id = current_user.id
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

  def contracts
    @class_name = 'Contract'
    @user = User.find(params[:id])
    @entries = Entry.where(contractor: @user).order('updated_at DESC')
    render 'contracts'
  end

  def entrusts
    @class_name = 'Entrust'
    @user = User.find(params[:id])
    @entries = Entry.where(owner: @user).order('updated_at DESC')
    render 'entrusts'
  end

  def following
    @title = 'follows'
    @no_user = 'No followed user'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'is followed by'
    @no_user = 'No follower'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def entries
    @user = User.find(params[:id])
    @contracts = []
    @entrusts = []
    entries = @user.entries
    entries.each do |entry|
      if entry.task.type == 'Offering'
        @contracts.push(entry)
      elsif entry.task.type == 'Want'
        @entrusts.push(entry)
      end
    end
    render 'entries'
  end
end
