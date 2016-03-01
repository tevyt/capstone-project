class Game < ActiveRecord::Base
	validates :name , presence: true

	def start()
		return false if active?
		update(start_time:  DateTime.now , active: true)
	end

	def terminate()
		return false unless active? 
		update(end_time: DateTime.now, active: false)
	end

end
