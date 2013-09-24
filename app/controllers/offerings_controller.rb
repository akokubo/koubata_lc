class OfferingsController < ApplicationController
  before_action :set_offering, only: [:show, :edit, :update, :destroy]

  def index
    @offerings = Offering.where(user: current_user)
  end

  def show
  end

  def new
    @offering = Offering.new
    #@offering.expired_at = Time.now.tomorrow
    @categories = Category.all
  end

  def edit
  end

  def create
    @offering = Offering.new(offering_params)
    @offering.user = current_user

    respond_to do |format|
      if @offering.save
        format.html { redirect_to @offering, notice: 'Offering was successfully created.' }
        format.json { render action: 'show', status: :created, location: @offering }
      else
        format.html { render action: 'new' }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @offering.update(offering_params)
        format.html { redirect_to @offering, notice: 'Offering was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @offering.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @offering.destroy
    respond_to do |format|
      format.html { redirect_to offerings_url }
      format.json { head :no_content }
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
      params.require(:offering).permit(:title, :category_id, :description, :price, :expired_at)
    end

end
