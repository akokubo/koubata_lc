class EntrustsController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @class_name = Entrust
    @entries = Entrust.all
  end

  def show
    @class_name = Entrust
    @task = @entry.task
    @negotiations = @entry.negotiations.order('created_at DESC').paginate(:page => params[:page])
    @negotiation = @entry.negotiations.build()
  end

  def new
    @class_name = Entrust
    @entry = Entrust.new
  end

  def edit
    @class_name = Entrust
    if @entry.user != current_user
      redirect_to @entry, alert: t('You cannot edit!')
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entrust.new(entry_params)
    @entry.user = current_user

    respond_to do |format|
      if @entry.save && notify_create
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.created', model: Entrust.model_name.human) }
        format.json { render :show, status: :created, location: @cantract }
      else
        format.html { render :new }
        format.json { render json: @cantract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:entrust][:performed_at]
      @entry.performed_at = Time.now
    end
    respond_to do |format|
      if @entry.save && notify_update
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.updated', model: Entrust.model_name.human) }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @entry.user == current_user
      @entry.destroy
      respond_to do |format|
        format.html { redirect_to entrusts_user_url(current_user) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to entrusts_user_url(current_user), alert: t('You cannot delete!') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Entrust.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entry_params
    params.require(:entrust).permit(:task_id, :user_id, :owner_contrctted_at, :user_contrctted_at, :paid_at, :created_at, :updated_at, :expected_at, :performed_at, :owner_canceled_at, :user_canceled_at, :note)
  end

  def notify_create
    Notification.create!(
      user: @entry.owner,
      body: "#{@entry.user.name}さんからの依頼があります。",
      url:  "/contracts/#{@entry.id}"
    )
  end

  def notify_update
    url = "/contracts/#{@entry.id}"
    if current_user == @entry.owner
      notification = Notification.find_by(user: @entry.user, url: url)
      if notification.nil?
        Notification.create!(
          user: @entry.user,
          body: "#{@entry.owner.name}さんからの連絡があります。",
          url:  url
        )
      else
        notification.update!(
          body: "#{@entry.owner.name}さんからの連絡があります。",
          read_at: nil
        )
      end
    elsif current_user == @entry.user
      notification = Notification.find_by(user: @entry.owner, url: url)
      if notification.nil?
        Notification.create!(
          user: @entry.owner,
          body: "#{@entry.user.name}さんからの連絡があります。",
          url:  url
        )
      else
        notification.update!(
          body: "#{@entry.user.name}さんからの連絡があります。",
          read_at: nil
        )
      end
    end
  end
end

