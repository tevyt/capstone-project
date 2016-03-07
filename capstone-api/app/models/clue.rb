class Clue < ActiveRecord::Base
	has_one :next_clue , class_name: 'Clue', foreign_key: 'previous_clue_id', dependent: :destroy
  belongs_to :game
	belongs_to :clue 
	validates :hint , :question , :answer , presence: true
	has_one :coordinate
end
