class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update]

  def index
    @users = User.where.not(id: current_user.id).active
  end

  def show
  end

  def edit
    @user = current_user
  end

  def update
    respond_to do |format|
      if @user == current_user && @user.update(user_params)
          format.html { redirect_to root_path, notice: t('activerecord.successful.messages.updated', model: User.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
    @entries = Entry.in_progress.where(contractor_id: @user.id).order('updated_at DESC')
    render 'contracts'
  end

  def entrusts
    @class_name = 'Entrust'
    @user = User.find(params[:id])
    @entries = Entry.in_progress.where(owner_id: @user.id).order('updated_at DESC')
    render 'entrusts'
  end

  def recent_contracts
    @class_name = 'Contract'
    @user = User.find(params[:id])
    not_finished = Entry.not_finished
    not_finished = not_finished.where_values.reduce(:and)
    not_owner_canceled = Entry.not_owner_canceled
    not_owner_canceled = not_owner_canceled.where_values.reduce(:and)
    not_contractor_canceled = Entry.not_contractor_canceled
    not_contractor_canceled = not_contractor_canceled.where_values.reduce(:and)
    @entries = Entry.where(not_finished.or(not_owner_canceled).or(not_contractor_canceled)).where(contractor_id: @user.id).order('updated_at DESC')
    render 'contracts'
  end

  def recent_entrusts
    @class_name = 'Entrust'
    @user = User.find(params[:id])
    not_finished = Entry.not_finished
    not_finished = not_finished.where_values.reduce(:and)
    not_owner_canceled = Entry.not_owner_canceled
    not_owner_canceled = not_owner_canceled.where_values.reduce(:and)
    not_contractor_canceled = Entry.not_contractor_canceled
    not_contractor_canceled = not_contractor_canceled.where_values.reduce(:and)
    @entries = Entry.where(not_finished.or(not_owner_canceled).or(not_contractor_canceled)).where(owner_id: @user.id).order('updated_at DESC')
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :description, :email)
  end
end
