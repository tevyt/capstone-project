class Game < ActiveRecord::Base
	validates :name , presence: true
	has_many :game_histories
	has_many :users, through: :game_histories

	def start()
		return false if active?
		update(start_time:  DateTime.now , active: true)
	end

	def terminate()
		return false unless active?
		update(end_time: DateTime.now, active: false)
	end

end
