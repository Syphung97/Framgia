class SessionsController < ApplicationController
  attr_reader :user
  def new
  end

  def create
    @user = User.find_by email: params_session[:email].downcase
    if user && user.authenticate(params_session[:password])
      login_successfull
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

  def login_false
    flash.now[:danger] = t "session.controller.invalid"
    render :new
  end
end
