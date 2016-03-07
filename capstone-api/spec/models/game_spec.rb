require 'rails_helper'

RSpec.describe Game, type: :model do
	before(:each) do
		@game = Game.new(name: 'Test')
		@clue = Clue.new(hint: 'Test Hint' , question: 'Test' , answer: 'Test')
	end


	it "should validate the precence of a name" do
		@game.name = nil
		expect(@game).to_not be_valid
	end
  
	it "should be inactive by default" do
		expect(@game.active?).to be false
	end

	it "should activate be able to activate games" do
		@game.start
		expect(@game).to_not be_a_new(Game)
		expect(@game.active?).to be true
		expect(@game.start_time).to  be_truthy
	end

	it "should not terminate an inactive game" do
		expect(@game.terminate).to be false
		expect(@game).to be_a_new(Game)
	end

	it "should terminate active games" do
		@game.start
		expect(@game.terminate).to be true
		expect(@game.active?).to be false
		expect(@game.end_time).to be_truthy
	end

	it "should not allow an active game to be activated" do
		@game.start
		expect(@game.start).to be false
	end


	it "should save a valid game" do
		expect(@game).to be_valid
	end

	it "should destroy clues when the game is destroyed" do
		@game.clues << @clue
		@game.save
		expect{@game.destroy}.to change(Clue, :count).by (-1)
	end

	it "should destroy the first clue when the game is destroyed" do
		@game.first_clue = @clue
		@game.save
		expect{@game.destroy}.to change(Clue, :count).by (-1)
	end

	it "should have a default radius of 1m" do
		@game.save
		expect(@game.radius).to equal 1
	end

	it "should not allow games with radius beyound possible values" do 
		@game.radius = 0
		expect(@game).to_not be_valid
		@game.radius = 12_742_000_000#Diameter of the earth
		expect(@game).to_not be_valid
	end

	it "should allow games with valid radii to be saved" do
		@game.radius = 100
		expect(@game).to be_valid
		@game.radius = 100_000_000
		expect(@game).to be_valid
	end

end
