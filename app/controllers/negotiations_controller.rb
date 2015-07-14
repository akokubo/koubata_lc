class NegotiationsController < ApplicationController
  before_action :authenticate_user!

  # POST /negotiations
  # POST /negotiations.json
  def create
    @negotiation = Negotiation.new(negotiation_params)
    @negotiation.sender = current_user

    if @negotiation.entry.type == "Contract"
      respond_to do |format|
        if @negotiation.save
          format.html { redirect_to contract_path(@negotiation.entry) }
          format.json { render :show, status: :created, location: @negotiation }
        else
          format.html { render :new }
          format.json { render json: @negotiation.errors, status: :unprocessable_entity }
        end
      end
    elsif  @negotiation.entry.type == "Entrust"
      respond_to do |format|
        if @negotiation.save
          format.html { redirect_to entrust_path(@negotiation.entry) }
          format.json { render :show, status: :created, location: @negotiation }
        else
          format.html { render :new }
          format.json { render json: @negotiation.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def negotiation_params
    params.require(:negotiation).permit(:body, :sender_id, :recepient_id, :entry_id)
  end
end
