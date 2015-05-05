class MessagesController < ApplicationController
  before_action :set_message, only: [:show]
  before_action :authenticate_user!

  # GET /messages
  # GET /messages.json
  def index
    # @messages = Message.all
    @companions = current_user.companions.uniq
  end

=begin
  # GET /messages/1
  # GET /messages/1.json
  def show
  end
=end

  # GET /messages/new
  def new
    if params.key?(:offering)
      offering = Offering.find(params[:offering])
      subject = "できること「#{offering.title}」の依頼"
      @recepients = User.where(id: offering.user_id)
    elsif params.key?(:want)
      want = Want.find(params[:want])
      subject = "頼みたいこと「#{want.title}」の引き受け"
      @recepients = User.where(id: want.user_id)
    else
      subject = ''
      @recepients = User.where('id != :id', id: current_user.id)
    end
    @message = Message.new(sender: current_user, subject: subject)
=begin
    @message = Message.new
    @message.sender_id = current_user.id
    if params.key?(:offering)
      offering = Offering.find(params[:offering])
      @message.subject = "できること「#{offering.title}」の依頼"
      @recepients = User.where(id: offering.user_id)
    elsif params.key?(:want)
      want = Want.find(params[:want])
      @message.subject = "頼みたいこと「#{want.title}」の引き受け"
      @recepients = User.where(id: want.user_id)
    else
      @recepients = User.where('id != :id', id: current_user.id)
    end
=end
  end

=begin
  # GET /messages/1/edit
  def edit
  end
=end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.subject ||= '無題'
    @message.sender = current_user

    if @message.sender_id != current_user.id
      redirect_to new_message_url
    else
      respond_to do |format|
        if @message.save
          format.html { redirect_to user_path(@message.recepient_id), notice: t('activerecord.successful.messages.created', model: Message.model_name.human) }
          format.json { render :show, status: :created, location: @message }
        else
          format.html { render :new }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end
  end

=begin
  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: t('activerecord.successful.messages.updated', :model => Message.model_name.human) }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    if @message.sender_id == current_user.id || @message.recepient_id == current_user.id
      @message.destroy
    end
    respond_to do |format|
      format.html { redirect_to messages_url, notice: t('activerecord.successful.messages.destroyed', model: Message.model_name.human) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
    @categories = Category.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:subject, :body, :sender_id, :recepient_id)
  end
end
