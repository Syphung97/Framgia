class User < ApplicationRecord
  enum genders: [:female, :male]
  attr_reader :remember_token, :activation_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}, presence: true,
    length: {maximum: Settings.maxemail}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.minpassword},
  allow_nil: true  
  validates :name, presence: true, length: {maximum: Settings.maxname}
  validates :gender, inclusion: {in: genders.keys}

  before_save :email_down
  before_create :create_activation_digest
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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? current_user
    self == current_user
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def update_active_digest
    create_activation_digest
    update_attributes activation_digest: activation_digest
  end

  private

  def email_down
    self.email = email.downcase
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
