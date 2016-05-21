module DistanceManager
  extend ActiveSupport::Concern

  included do
    Float.class_eval do
      def to_radians
        self.to_f * Math::PI/180
      end 
    end
    #Given 2 coordinates get the distance in meters between them uses Haversine Formula
    def meter_distance(coordinate1 , coordinate2)
      latitude_difference = (coordinate2[:latitude] - coordinate1[:latitude]).abs.to_radians
      longitude_difference = (coordinate2[:longitude] - coordinate1[:longitude]).abs.to_radians 
      a = Math.sin(latitude_difference/2)**2 + \
        Math.cos(coordinate1[:latitude].to_radians) * Math.cos(coordinate2[:latitude].to_radians) *\
        Math.sin(longitude_difference/2)**2
      c = 2 * Math.atan2(Math.sqrt(a) , Math.sqrt(1 - a))
      6_371 * c * 1000
    end
  end
end
