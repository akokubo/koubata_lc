class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def show
    @task = Task.new(
      title: @entry.title,
      description: @entry.description,
      price_description: @entry.prior_price_description,
      category: @entry.category,
      user: @entry.owner
    )
    @negotiations = @entry.negotiations.order('created_at DESC').paginate(page: params[:page])
    @negotiation = @entry.negotiations.build
  end

  # POST /entries
  # POST /entries.json
  def create
    task = Task.find(params[:entry][:task_id])
    if task.type == 'Offering'
      owner = current_user
      contractor = task.user
    elsif task.type == 'Want'
      owner = task.user
      contractor = current_user
    end

    @entry = Entry.new(entry_params)
    @entry.task = task
=begin
    @entry.title = task.title
    @entry.description = task.description
    @entry.prior_price = task.price
    @entry.expired_at = task.expired_at
    @entry.category = task.category
=end
    @entry.owner = owner
    @entry.contractor = contractor
    @entry = current_user.entry!(@entry)

    respond_to do |format|
      if @entry
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.created', model: Entry.model_name.human) }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # @entry.performed_at = Time.now if params[:contract][:performed_at].present?

    if params[:force_commit].present?
      options = {}

      if (entry_params.key?("expected_at(1i)") && entry_params["expected_at(1i)"].present?)
        temp_expected_at = Time.new(entry_params["expected_at(1i)"].to_i, entry_params["expected_at(2i)"].to_i, entry_params["expected_at(3i)"].to_i, entry_params["expected_at(4i)"].to_i, entry_params["expected_at(5i)"].to_i)
        options[:expected_at] = temp_expected_at
      end
      if (entry_params.key?(:price) && entry_params[:price].present?)
        options[:price] = entry_params[:price]
      end
      @entry = current_user.commit!(@entry, options)
    end

    @entry = current_user.cancel!(@entry) if params[:cancel].present?
    @entry = current_user.perform!(@entry) if params[:perform].present?
    @entry = current_user.pay_for!(@entry, amount: params[:entry][:amount], comment: params[:entry][:comment]) if params[:pay].present?

    respond_to do |format|
      if @entry
        format.html { redirect_to @entry, notice: t('activerecord.successful.messages.updated', model: Entry.model_name.human) }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { redirect_to @entry }
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
    @entry = Entry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def entry_params
    params.require(:entry).permit(
      :expected_at,
      :price
    )
  end
end
