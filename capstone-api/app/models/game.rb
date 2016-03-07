class Game < ActiveRecord::Base
	validates :name , presence: true
	validates :radius , numericality: {greater_than: 0 , less_than: 6_371_000_000} #Radius can't be bigger than the radius of the earth!
	has_many :game_histories
	has_many :users, through: :game_histories
	has_many :clues , dependent: :destroy
	has_one :first_clue , class_name: "Clue", dependent: :destroy

	def start()
		return false if active?
		update(start_time:  DateTime.now , active: true)
	end

	def terminate()
		return false unless active?
		update(end_time: DateTime.now, active: false)
	end

	private 
	def intersect?(coordinate1 , coordinate2)
		meter_distance(coordinate1 , coordinate2) <= @radius	
	end

	#Given 2 coordinates get the distance in meters between them uses Haversine Formula
	def meter_distance(coordinate1 , coordinate2)
		latitude_difference = (coordinate2.latitude - coordinate1.latitude).abs.to_radians
		longitude_difference = (coordinate2.longitude - coordinate1.longitude).abs.to_radians 
		a = Math.sin(latitude_difference/2)**2 + \
									 Math.cos(coordinate1.latitude.to_radians) * Math.cos(coordinat2.latitude.to_radians) *\
									 Math.sin(longitude_difference/2)**2
		c = 2 * Math.atan2(Math.sqrt(a) , Math.sqrt(1 - a))
		6_371 * c
	end
end

class Float
	def to_randians
		self.to_f * Math::PI/180
	end
end
