class ContractsController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @class_name = Contract
    @entries = Contract.all
  end

  def show
    @class_name = Contract
    @task = @entry.task
    @negotiations = @entry.negotiations.order('created_at DESC').paginate(page: params[:page])
    @negotiation = @entry.negotiations.build
  end

  def new
    @class_name = Contract
    @entry = Contract.new
  end

  def edit
    @class_name = Contract
    if @entry.user != current_user
      redirect_to @entry, alert: t('You cannot edit!')
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Contract.new(entry_params)

    respond_to do |format|
      if @entry = current_user.entry!(@entry)
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.created', model: Contract.model_name.human) }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # @entry.performed_at = Time.now if params[:contract][:performed_at].present?
    @entry = current_user.commit!(@entry, entry_params) if params[:commit].present?

    respond_to do |format|
      if @entry
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.updated', model: Contract.model_name.human) }
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
        format.html { redirect_to contracts_user_url(current_user) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to contracts_user_url(current_user), alert: t('You cannot delete!') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Contract.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entry_params
    params.require(:contract).permit(
      :task_id,
      :expected_at,
      :price
    )
  end
end
