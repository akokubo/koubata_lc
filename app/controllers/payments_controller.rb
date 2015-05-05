class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show]
  before_action :authenticate_user!

  def index
    @payments = Payment.find_by_from_id_or_to_id(current_user.id)
    # @withs = Payment.withs(current_user.id)
  end

  def show
  end

  def new
    @payment = Payment.new
    @tos = User.where("id != '#{current_user.id}'")
  end

=begin
  def edit
  end
=end

  def create
    @payment = Payment.new(payment_params)
    @payment.from = current_user.account
    @payment.subject = '無題' unless @payment.subject
    @payment.balance = Account.find_by(user_id: current_user.id).balance - @payment.amount
    @tos = User.where("id != '#{current_user.id}'")

    respond_to do |format|
      if @payment.save
        format.html { redirect_to accounts_url, notice: t('activerecord.successful.messages.created', model: Payment.model_name.human) }
        format.json { render action: 'show', status: :created, location: @payment }
      else
        format.html { render action: 'new' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

=begin
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: t('activerecord.successful.messages.updated', :model => Payment.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
=end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:payment).permit(:from_id, :to_id, :subject, :amount, :comment)
  end
end
