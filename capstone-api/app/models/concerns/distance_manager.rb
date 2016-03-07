module DistanceManager
	extend ActiveSupport::Concern

	included do
		Float.class_eval do
			def to_radians
				self.to_f * Math::PI/180
			end 
		end
	end
end
