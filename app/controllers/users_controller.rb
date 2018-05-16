class UsersController < ApplicationController
  before_action :return_genders, only: [:new, :edit, :create]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :find_user, only: [:edit, :update, :destory, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      require_active
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "users.update.success"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :gender
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.update.logged_in_user"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "users.show.error"
    redirect_to root_path
  end

  def require_active
    user.send_activation_email
    flash[:info] = t "mailer.account_activation.message"
    redirect_to root_url
  end

  def return_genders
    @genders = User.genders
  end
end
