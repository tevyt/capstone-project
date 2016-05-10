require 'rails_helper'

RSpec.describe Coordinate, type: :model do
	before (:each) do
		@coordinate = Coordinate.new(latitude: 18.003 , longitude: -76.7446) #This is on UWI campus
	end
	

end
