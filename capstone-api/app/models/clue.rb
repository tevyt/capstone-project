class Clue < ActiveRecord::Base
  belongs_to :game
  validates :hint , :question , :answer , presence: true
  has_one :coordinate
end
