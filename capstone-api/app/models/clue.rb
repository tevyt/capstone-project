class Clue < ActiveRecord::Base
	has_one :next_clue , class_name: 'Clue', foreign_key: 'previous_clue_id'
  belongs_to :game
end
