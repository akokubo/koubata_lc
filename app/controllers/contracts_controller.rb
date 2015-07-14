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
    @negotiations = @entry.negotiations(@user).order('created_at DESC').paginate(:page => params[:page])
    @negotiation = @entry.negotiations.build(
      sender_id: current_user.id,
      recepient_id: @task.user.id
    )
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
    @entry.user = current_user
 
    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Contract was was successfully created.' }
        format.json { render :show, status: :created, location: @cantract }
      else
        format.html { render :new }
        format.json { render json: @cantract.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    old_entry = Entry.find(params[:id])
    @entry = Entry.find(params[:id])
    @entry.assign_attributes(entry_params)
    if params[:contract][:owner_contract]
      if old_entry.expected_at != @entry.expected_at
        @entry.owner_contracted_at = Time.now
        @entry.user_contracted_at = nil
        @entry.save
      else
        @entry.owner_contracted_at = Time.now
        @entry.save
      end
      redirect_to @entry
    elsif params[:contract][:user_contract]
      if old_entry.expected_at != @entry.expected_at
        @entry.owner_contracted_at = nil
        @entry.user_contracted_at = Time.now
        @entry.save
      else
        @entry.user_contracted_at = Time.now
        @entry.save
      end
      redirect_to @entry
    elsif params[:contract][:owner_cancel]
      @entry.update_attribute(:owner_canceled_at, Time.now)
      redirect_to @entry
    elsif params[:contract][:user_cancel]
      @entry.update_attribute(:user_canceled_at, Time.now)
      redirect_to @entry
    else
      respond_to do |format|
        if @entry.user == current_user && @entry.update(entry_params)
          format.html { redirect_to @entry, notice: 'Contract was successfully updated.' }
          format.json { render :show, status: :ok, location: @entry }
        else
          format.html { render :edit }
          format.json { render json: @entry.errors, status: :unprocessable_entity }
        end
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
    params.require(:contract).permit(:task_id, :user_id, :contracted_at, :paid_at, :expected_at, :performed_at, :owner_canceled_at, :user_canceled_at, :note)
  end
end
