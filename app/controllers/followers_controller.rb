class FollowersController < ApplicationController
  attr_reader :user

  before_action :logged_in_user, :find_user, only: %i(index)

  def index
    @title = t "followers"
    @users = user.followers.paginate page: params[:page]
    render "users/show_follow"
  end

  private

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:success] = t "failed_user"
    redirect_to root_path
  end
end
