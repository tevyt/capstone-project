class Clue < ActiveRecord::Base
  belongs_to :game
  belongs_to :game_history
  validates :hint , :question , :answer , presence: true
  has_one :coordinate
end
