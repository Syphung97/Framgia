class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy, :inline_edit, :update]

  def create
    @micropost = current_user.microposts.build micropost_params
    if micropost.save
      respond
    else
      @feed_items = current_user.feed.desc.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def inline_edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if micropost.update_attributes micropost_params
      respond_to do |format|
        format.js
      end
    else
      redirect_to root_url
    end
  end

  def destroy
    micropost.destroy
    respond
    flash[:success] = t "micropost_deleted"
  end

  private

  attr_reader :micropost

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def respond
    respond_to do |format|
      format.html{redirect_to root_url}
      format.js
    end
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless micropost
  end
end
