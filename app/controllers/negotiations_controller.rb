class NegotiationsController < ApplicationController
  before_action :authenticate_user!

  # POST /negotiations
  # POST /negotiations.json
  def create
    @negotiation = Negotiation.new(negotiation_params)
    @negotiation.sender = current_user
    @negotiation.recepient = @negotiation.entry.partner_of(current_user)

    if @negotiation.entry.type == 'Contract'
      path = contract_path(@negotiation.entry)
    elsif  @negotiation.entry.type == 'Entrust'
      path entrust_path(@negotiation.entry)
    else
      fail 'Entry type is invalid'
    end

    respond_to do |format|
      if @negotiation.save
        format.html { redirect_to path }
        format.json { render :show, status: :created, location: @negotiation }
      else
        format.html { render :new }
        format.json { render json: @negotiation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def negotiation_params
    params.require(:negotiation).permit(:body, :entry_id)
  end
end
