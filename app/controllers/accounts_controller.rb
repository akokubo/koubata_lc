class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @payments = Payment.where(user: current_user.account)
  end
end
