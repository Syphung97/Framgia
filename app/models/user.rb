class User < ApplicationRecord
  enum genders: [:female, :male]
  attr_reader :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}, presence: true,
    length: {maximum: Settings.maxemail}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.minpassword},
    allow_nil: true
  validates :name, presence: true, length: {maximum: Settings.maxname}
  validates :gender, inclusion: {in: genders.keys}

  before_save :email_down
  has_secure_password

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? current_user
    self == current_user
  end
  private

  def email_down
    self.email = email.downcase
  end
end
