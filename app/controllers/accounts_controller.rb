class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = Payment.find_by_from_id_or_to_id(current_user.id)
    # @withs = Payment.withs(current_user.id)
  end
end
