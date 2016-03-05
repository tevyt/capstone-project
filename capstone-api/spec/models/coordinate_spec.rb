require 'rails_helper'

RSpec.describe Coordinate, type: :model do
	before (:each) do
		@coordinate = Coordinate.new(latitude: 18.003 , longitude: 76.7446) #This is on UWI campus
	end
	
	it "should invalidate latitude outside valid range" do
		invalid_properties = [ -90.5 ,  90.5]
		invalidate_properties(@coordinate , :latitude= , invalid_properties)
	end

	def invalidate_properties(model, set_method , invalid_properties)
		invalid_properties.each do |value|
			@coordinate.send(:latitude= , value)
			expect(@coordinate).to_not be_valid
		end
	end
end
