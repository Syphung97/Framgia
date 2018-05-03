class User < ApplicationRecord
  enum genders: [:male, :female]
  before_validation :gender_valid

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: {with: VALID_EMAIL_REGEX}, presence: true,
    length: {maximum: Settings.maxemail}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.minpassword}
  validates :name, presence: true, length: {maximum: Settings.maxname}
  validates :gender, inclusion: {in: genders.keys}

  before_save :email_down
  has_secure_password

  private

  def email_down
    self.email = email.downcase
  end
end
