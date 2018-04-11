class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
