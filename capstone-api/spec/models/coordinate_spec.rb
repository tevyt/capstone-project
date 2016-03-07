require 'rails_helper'

RSpec.describe Coordinate, type: :model do
	before (:each) do
		@coordinate = Coordinate.new(latitude: 18.003 , longitude: 76.7446) #This is on UWI campus
	end
	
	it "should invalidate latitude outside valid range" do
		invalid_properties = [ -90.5 ,  90.5]
		invalidate_properties(@coordinate , :latitude= , invalid_properties)
	end

	it "should invalidate longitude outside valid range" do
		invalid_properties = [-181 , 181]
		invalidate_properties(@coordinate , :longitude= , invalid_properties)
	end

	it "should accept a valid coordinates" do
		expect(@coordinate).to be_valid
	end

	it "should accept coordinates at the extremes" do
		@coordinate.latitude = 90
		@coordinate.longitude = 180
		expect(@coordinate).to be_valid
	end

	def invalidate_properties(model, set_method , invalid_properties)
		invalid_properties.each do |value|
			clone = model.clone
			clone.send(set_method , value)
			expect(clone).to_not be_valid
		end
	end
end
