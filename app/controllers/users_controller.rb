class UsersController < ApplicationController
  include UsersHelper

  def new
    @user = User.new
    @genders = User.genders
  end

  def create
    @genders = User.genders
    @user = User.new user_params
    if user.save
      flash[:danger] = t "users.new.success"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "users.show.error"
    redirect_to root_path
  end
  private

  attr_reader :user

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :gender
  end
end
