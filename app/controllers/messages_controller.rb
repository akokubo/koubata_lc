class MessagesController < ApplicationController
  before_action :set_message, only: [:show]
  before_action :authenticate_user!

  def index
    @messages = Message.list(current_user.id)
    @withs = Message.withs(current_user.id)
  end

=begin
  def show
  end
=end

  def new
    @message = Message.new
    @tos = User.where("id != '#{current_user.id}'")
    if (params[:offering])
      offering = Offering.find(params[:offering])
      @message.subject = "できること「#{offering.title}」の依頼"
      @tos = User.where(id: offering.user_id)
    end
    if (params[:want])
      want = Want.find(params[:want])
      @message.subject = "頼みたいこと「#{want.title}」の引き受け"
      @tos = User.where(id: want.user_id)
    end
  end

=begin
  def edit
  end
=end

  def create
    @message = Message.new(message_params)
    @message.from = current_user
    @message.subject = "無題" unless @message.subject
    @tos = User.where("id != '#{current_user.id}'")

    respond_to do |format|
      if @message.save
        format.html { redirect_to "/users/#{@message.to_id}/messages", notice: t('activerecord.successful.messages.created', :model => Message.model_name.human) }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

=begin
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: t('activerecord.successful.messages.updated', :model => Message.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
=end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
      @categories = Category.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:from_id, :to_id, :subject, :body)
    end

end
