class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @payments = Payment.with(current_user.account)
  end
end
