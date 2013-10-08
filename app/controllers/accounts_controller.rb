class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = Payment.list(current_user.id)
    @withs = Payment.withs(current_user.id)
  end
end
