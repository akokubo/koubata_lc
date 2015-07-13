class TalksController < ApplicationController
  before_action :authenticate_user!

  # GET /talks
  # GET /talks.json
  def index
    @companions = current_user.companions.uniq
  end

  # GET /talks/new
  def new
    @recepients = User.where('id != :id', id: current_user.id)
    @talk = Talk.new(sender: current_user)
  end

  # POST /talks
  # POST /talks.json
  def create
    @talk = Talk.new(talk_params)
    @talk.sender = current_user

    respond_to do |format|
      if @talk.save
        format.html { redirect_to talks_user_path(@talk.recepient) }
        format.json { render :show, status: :created, location: @talk }
      else
        format.html { render :new }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def talk_params
    params.require(:talk).permit(:body, :sender_id, :recepient_id)
  end
end
