class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show]
  before_action :authenticate_user!

  def index
    @payments = Payment.with(current_user.account)
  end

  def show
  end

  def new
    @payment = Payment.new
    @recepients = User.where.not(id: current_user.id).active

    if params[:contract]
      contract = Contract.find(params[:contract])
      contract.paid_at = Time.now
      contract.save
      @payment.subject = "「#{contract.task.title}」の支払い"
      @recepients = User.where(id: contract.task.user_id)
    end

    if params[:entrust]
      entrust = Entrust.find(params[:entrust])
      entrust.paid_at = Time.now
      entrust.save
      @payment.subject = "「#{entrust.task.title}」の支払い"
      @recepients = User.where(id: entrust.user_id)
    end

=begin
    @partner_account_ids = []
    @partners.each do |partner|
      #partner.account_id = partner.account.id
      @partner_account_ids.push(partner.account.id)
    end
    #@tos = Account.where(id: partner_accounts)
=end
  end

=begin
  def edit
  end
=end

  def create
    @payment = Payment.new(payment_params)
    begin
      Account.transfer(
        sender_account: current_user.account,
        recepient_account: Account.find(@payment.recepient_account_id),
        amount: @payment.amount,
        subject: @payment.subject,
        comment: @payment.comment
      )
      redirect_to account_url, notice: t('activerecord.successful.messages.created', model: Payment.model_name.human)
    rescue
      @recepients = User.where.not(id: current_user.id).active
      render action: 'new'
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
    params.require(:payment).permit(:recepient_account_id, :subject, :amount, :comment)
  end
end
