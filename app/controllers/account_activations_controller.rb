class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      active_success user
    else
      active_false
    end
  end

  private

  def active_success user
    user.activate
    log_in user
    flash[:success] = t "mailer.account_activation.account_activated"
    redirect_to user
  end

  def active_false
    flash[:danger] = t "mailer.account_activation.invalid"
    redirect_to root_url
  end
end
