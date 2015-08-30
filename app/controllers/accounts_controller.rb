class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @payments = Payment.where('sender_id = :current_user OR recepient_id = :current_user', current_user: current_user).order('created_at DESC')
  end
end
