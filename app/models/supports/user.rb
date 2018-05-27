class Supports::User
  attr_reader :user, :current_user

  def initialize arg = {}
    @user = arg[:user]
    @current_user = arg[:current_user]
  end

  def new_relation
    @new_relation = current_user.active_relationships.build
  end

  def current_relation
    @current_relation =
      current_user.active_relationships.find_by followed_id: user.id
  end
end
