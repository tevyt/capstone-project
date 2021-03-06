require 'securerandom'
class User < ActiveRecord::Base
  has_many :game_histories
  has_many :games, through: :game_histories
  has_many :games
  has_many :tokens
  before_save :downcase_email, :set_auth_token
  validates :email , presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: {case_sensitive: false}
  validates :password ,presence: true, length: {minimum:8}, on: :create
  validates :firstname, presence: true
  validates :lastname, presence: true
  has_secure_password


  protected
  def downcase_email
    self.email.downcase!
  end

  def set_auth_token
    return if auth_token.present?
    self.auth_token = generated_auth_token
  end

  def generated_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end

end
