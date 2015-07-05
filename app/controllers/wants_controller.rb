class WantsController < ApplicationController
  before_action :set_want, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @wants = Want.all
  end

  def show
  end

  def new
    @want = Want.new
    @want.expired_at = Time.zone.now.tomorrow
    @categories = Category.all
  end

  def edit
    @want = Want.find(params[:id])
    @categories = Category.all
    if @want.user != current_user
      redirect_to @want, alert: t('You cannot edit!')
    end
  end

  def create
    @want = Want.new(want_params)
    @want.user = current_user
    @categories = Category.all

    respond_to do |format|
      if @want.save

        format.html { redirect_to @want, notice: t('activerecord.successful.messages.created', model: Want.model_name.human) }
        format.json { render action: 'show', status: :created, location: @want }
      else
        format.html { render action: 'new' }
        format.json { render json: @want.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @want.user == current_user
      if want_params[:submit_hire]
        update_hire(@want, want_params)
        redirect_to @want
      else
        @categories = Category.all
        respond_to do |format|
          if @want.update(want_params)
            format.html { redirect_to @want, notice: t('activerecord.successful.messages.updated', model: Want.model_name.human) }
            format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            format.json { render json: @want.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @want, alert: t('You cannot edit!') }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    if @want.user == current_user
      @want.destroy
      respond_to do |format|
        format.html { redirect_to wants_user_url(current_user) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to wants_user_url(current_user), alert: t('You cannot delete!') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_want
    @want = Want.find(params[:id])
    @categories = Category.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def want_params
    params.require(:want).permit(:title, :category_id, :description, :price, :expired_at, :no_expiration, :hired_id, :submit_hire)
  end


  def update_hire(want, want_params)
    if want_params[:hired_id]
      hired_id = want_params[:hired_id].to_i
      entries = want.entries
      entries.each do |entry|
        if entry.id == hired_id
          entry.hired_at = Time.now
        else
          entry.hired_at = nil
        end
        entry.save
      end
      want.expired_at = Time.now
      want.save
    else
      entries = want.entries
      entries.each do |entry|
        entry.hired_at = nil
        entry.save
      end
      want.expired_at = nil
      want.save
    end
  end
end
