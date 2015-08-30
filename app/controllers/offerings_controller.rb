class OfferingsController < ApplicationController
  before_action :set_offering, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @categories = Category.all
    @class_name = Offering
  end

  def show
    @class_name = Offering
    @task = @offering
    @entry = @offering.contracts.build
  end

  def new
    @class_name = Offering
    @offering = Offering.new
    @offering.expired_at = Time.zone.now
    @task = @offering
    @categories = Category.all
  end

  def edit
    @class_name = Offering
    @offering = Offering.find(params[:id])
    @task = @offering
    @categories = Category.all
    if @offering.user != current_user
      redirect_to @offering, alert: t('You cannot edit!')
    end
  end

  def create
    @offering = Offering.new(offering_params)
    @offering.user = current_user
    @categories = Category.all

    respond_to do |format|
      if @offering.save
        format.html { redirect_to @offering, notice: t('activerecord.successful.messages.created', model: Offering.model_name.human) }
        format.json { render action: 'show', status: :created, location: @offering }
      else
        format.html { render action: 'new' }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @offering.user == current_user
      if offering_params[:submit_hire]
        update_hire(@offering, offering_params)
        redirect_to @offering
      else
        @categories = Category.all
        respond_to do |format|
          if @offering.update(offering_params)
            format.html { redirect_to @offering, notice: t('activerecord.successful.messages.updated', model: Offering.model_name.human) }
            format.json { head :no_content }
          else
            format.html { render action: 'edit' }
            format.json { render json: @offering.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @offering, alert: t('You cannot edit!') }
        format.json { head :no_content }
      end
    end
  end

  def destroy
    if @offering.user == current_user
      @offering.destroy
      respond_to do |format|
        format.html { redirect_to offerings_user_url(current_user) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to offerings_user_url(current_user), alert: t('You cannot delete!') }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_offering
    @offering = Offering.find(params[:id])
    @categories = Category.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def offering_params
    params.require(:offering).permit(:title, :category_id, :description, :price, :expired_at, :no_expiration, :hired_id, :submit_hire)
  end

  def update_hire(offering, offering_params)
    if offering_params[:hired_id]
      hired_id = offering_params[:hired_id].to_i
      entries = offering.entries
      entries.each do |entry|
        if entry.id == hired_id
          entry.hired_at = Time.now
        else
          entry.hired_at = nil
        end
        entry.save
      end
      offering.expired_at = Time.now
      offering.save
    else
      entries = offering.entries
      entries.each do |entry|
        entry.hired_at = nil
        entry.save
      end
      offering.expired_at = nil
      offering.save
    end
  end
end
