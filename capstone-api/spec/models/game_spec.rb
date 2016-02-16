require 'rails_helper'

RSpec.describe Game, type: :model do
	before(:each) do
		@game = Game.new(name: 'Test' , duration: 10)
	end
	it "should validate the precence of a name" do
		@game.name = nil
		expect(@game).to_not be_valid
	end

	it "should not save a game without a duration" do
		@game.duration = nil
		expect(@game).to_not be_valid
	end
	
	it "should save a valid game" do
		expect(@game).to be_valid
	end

end
