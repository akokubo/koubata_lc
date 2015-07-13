class TalksController < ApplicationController
  before_action :set_talk, only: [:show]
  before_action :authenticate_user!

  # GET /talks
  # GET /talks.json
  def index
    # @talks = Talk.all
    @companions = current_user.companions.uniq
  end

=begin
  # GET /talks/1
  # GET /talks/1.json
  def show
  end
=end

  # GET /talks/new
  def new
    if params.key?(:offering)
      offering = Offering.find(params[:offering])
      entry = current_user.entry!(offering)
      @recepients = User.where(id: offering.user_id)
    elsif params.key?(:want)
      want = Want.find(params[:want])
      entry = current_user.entry!(want)
      @recepients = User.where(id: want.user_id)
    else
      @recepients = User.where('id != :id', id: current_user.id)
    end
    @talk = Talk.new(sender: current_user)
=begin
    @talk = Talk.new
    @talk.sender_id = current_user.id
    if params.key?(:offering)
      offering = Offering.find(params[:offering])
      @recepients = User.where(id: offering.user_id)
    elsif params.key?(:want)
      want = Want.find(params[:want])
      @recepients = User.where(id: want.user_id)
    else
      @recepients = User.where('id != :id', id: current_user.id)
    end
=end
  end

=begin
  # GET /talks/1/edit
  def edit
  end
=end

  # POST /talks
  # POST /talks.json
  def create
    @talk = Talk.new(talk_params)
    @talk.sender = current_user

    if @talk.sender_id != current_user.id
      redirect_to new_talk_url
    else
      respond_to do |format|
        if @talk.save
          format.html { redirect_to talks_user_path(@talk.recepient_id), notice: t('activerecord.successful.messages.created', model: Talk.model_name.human) }
          format.json { render :show, status: :created, location: @talk }
        else
          format.html { render :new }
          format.json { render json: @talk.errors, status: :unprocessable_entity }
        end
      end
    end
  end

=begin
  # PATCH/PUT /talks/1
  # PATCH/PUT /talks/1.json
  def update
    respond_to do |format|
      if @talk.update(talk_params)
        format.html { redirect_to @talk, notice: t('activerecord.successful.talks.updated', :model => Talk.model_name.human) }
        format.json { render :show, status: :ok, location: @talk }
      else
        format.html { render :edit }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /talks/1
  # DELETE /talks/1.json
  def destroy
    if @talk.sender_id == current_user.id || @talk.recepient_id == current_user.id
      @talk.destroy
    end
    respond_to do |format|
      format.html { redirect_to talks_url, notice: t('activerecord.successful.talks.destroyed', model: Talk.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.find(params[:id])
    @categories = Category.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def talk_params
    params.require(:talk).permit(:body, :sender_id, :recepient_id, :entry_id)
  end
end
