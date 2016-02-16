class Game < ActiveRecord::Base
	validates :name , presence: true
	validates :duration ,presence: true
end
