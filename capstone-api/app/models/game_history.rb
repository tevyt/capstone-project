class GameHistory < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_many :clues
end
