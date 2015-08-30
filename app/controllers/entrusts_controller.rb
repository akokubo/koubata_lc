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
    @negotiations = @entry.negotiations.order('created_at DESC').paginate(page: params[:page])
    @negotiation = @entry.negotiations.build
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
    @entrust = Entrust.new(entry_params)

    respond_to do |format|
      if @entrust = current_user.entry!(@entrust)
        format.html { redirect_to @entrust, notice: t('activerecord.successful.messages.created', model: Entrust.model_name.human) }
        format.json { render :show, status: :created, location: @cantract }
      else
        format.html { render :new }
        format.json { render json: @cantract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry.performed_at = Time.now if params[:entrust][:performed_at].present?

    respond_to do |format|
      if @entry.save
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
    params.require(:entrust).permit(
      :task_id,
      :expected_at,
      :price
    )
  end
end
