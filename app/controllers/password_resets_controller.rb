class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user,
    :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if user
      request_reset_password
    else
      flash.now[:danger] = t "reset_password.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      update_false
    elsif user.update_attributes user_params
      update_success
    else
      render :edit
    end
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def request_reset_password
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "reset_password.send_email"
    redirect_to root_url
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if user
    flash[:error] = t "reset_password.edit.user_not_exist"
    redirect_to root_url
  end

  def valid_user
    redirect_to root_url unless check_user
  end

  def check_user
    user && user.activated? && user.authenticated?(:reset, params[:id])
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "reset_password.edit.expire"
    redirect_to new_password_reset_url
  end

  def update_success
    log_in user
    user.update_attributes reset_digest: nil
    flash[:success] = t "reset_password.edit.success"
    redirect_to user
  end

  def update_false
    user.errors.add :password, t("reset_password.edit.error")
    render :edit
  end
end
