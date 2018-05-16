class SessionsController < ApplicationController
  attr_reader :user
  def new
  end

  def create
    @user = User.find_by email: params_session[:email].downcase
    if user && user.authenticate(params_session[:password])
      if user.activated?
        login_successfull
      else
        user_not_activeted
      end
    else
      login_false
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_successfull
    log_in user
    remember user if params[:session][:remember_me] == "1"
    redirect_back_or user
  end

  def user_not_activeted
    message = t "mailer.account_activation.warning"
    flash[:warning] = message
    user.update_active_digest
    user.send_activation_email
    redirect_to root_url
  end

  def login_false
    flash.now[:danger] = t "session.controller.invalid"
    render :new
  end
end
