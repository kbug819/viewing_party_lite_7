# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password

  has_secure_password
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties

  def self.user_host_name(id)
    user = User.find(id)
    user.name
  end

  def self.all_users_except_self(user)
    User.excluding(user)
  end
end
