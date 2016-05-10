require 'rails_helper'

RSpec.describe Game, type: :model do
	before(:each) do
    @game = Game.new(name: 'Test', start_time: 3.minutes.from_now, end_time: 5.minutes.from_now)
		@clue = Clue.new(hint: 'Test Hint' , question: 'Test' , answer: 'Test', longitude: 30, latitude: 70)
	end


	it "should validate the precence of a name" do
		@game.name = nil
		expect(@game).to_not be_valid
	end

	it "should be inactive by default" do
		expect(@game.active?).to be false
	end

	it "should not terminate an inactive game" do
		expect(@game.terminate).to be false
		expect(@game).to be_a_new(Game)
	end

	it "should save a valid game" do
		expect(@game).to be_valid
	end

	it "should destroy clues when the game is destroyed" do
		@game.clues << @clue
		@game.save
		expect{@game.destroy}.to change(Clue, :count).by (-1)
	end

	it "should have a default radius of 1m" do
		@game.save
		expect(@game.radius).to equal 1
	end

	it "should not allow games with radius beyond possible values" do
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

	it "should return the distance between 2 points" do
		tokyo = {latitude: 35.5533 , longitude: 139.7811}#Haneda
		kingston = {latitude: 17.9356 , longitude: -76.7875}#Norman Manley
		distance = Game.new.send(:meter_distance , tokyo , kingston)
		expect(distance).to be_within(150).of(12_928_536.276)#Distance in meters? Margin of error too big?  I mean it is kinda far
	end

  it "should be able to tell if 2 coordinates are too close" do
    @game.radius = 5
    place1 = {latitude: 17.9356 , longitude: -76.7875}
    place2 = {latitude: 17.9356 , longitude: -76.7875}
    expect(@game.send(:intersect? , place1 , place2)).to be true
  end

  it "should be able to tell if 2 coordinates are far enough apart" do
    @game.radius = 100
		tokyo = {latitude: 35.5533 , longitude: 139.7811}#Haneda
		kingston = {latitude: 17.9356 , longitude: -76.7875}#Norman Manley
    expect(@game.send(:intersect?, tokyo , kingston)).to be false
  end

  it "should be able to add valid clues that do not intersect" do
    clue_1 = Clue.new(hint: 'Test Hint' , question: 'Test' , answer: 'Test', latitude: 35.5533, longitude: 139.7811)
    clue_2 = Clue.new(hint: 'Test Hint' , question: 'Test' , answer: 'Test', latitude: 17.9356, longitude: -76.7875)
    @game.add_clue(clue_1)
    @game.add_clue(clue_2)
    expect(@game.clues.size).to eq 2
  end

  it "should not allow for the addition of clues that intersect" do
    @clue.coordinate.update(latitude: 17.9356 , longitude: -76.7875)
    expect(@game.add_clue(@clue)).to be_truthy
    expect(@game.add_clue(@clue.clone)).to be false
    expect(@game.clues.size).to eq 1
  end

  it "should not allow a start date in the past" do
    @game.start_time = 3.days.ago
    expect(@game).to_not be_valid
  end
  
  it "should not allow a end date in the past" do
  	@game.end_time = 3.days.ago
  	expect(@game).to_not be_valid
  end
end
