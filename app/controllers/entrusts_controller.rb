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
    @user = @task.user
#    @messages = current_user.messages(@user).where(entry_id: @entry.id).order('created_at DESC').paginate(:page => params[:page])
    @messages = @entry.messages.order('created_at DESC').paginate(:page => params[:page])
    @message = @entry.messages.build(recepient_id: @user.id, sender_id: current_user.id)
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
 
    respond_to do |format|
      if @entry.user == current_user && @entry.save
        format.html { redirect_to @entry, notice: 'Entrust was was successfully created.' }
        format.json { render :show, status: :created, location: @cantract }
      else
        format.html { render :new }
        format.json { render json: @cantract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.user == current_user && @entry.update(entry_params)
        format.html { redirect_to @contact, notice: 'Entrust was successfully updated.' }
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
    params.require(:entrust).permit(:task_id, :user_id, :entrusted_at, :paid_at, :created_at, :updated_at, :expected_at, :performed_at, :owner_canceled_at, :user_canceled_at, :note)
  end
end
