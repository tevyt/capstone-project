require 'rails_helper'

RSpec.describe Clue, type: :model do
	before(:each) do
		@clue = Clue.new(hint: 'Test' , question: 'Test' , answer: 'Test')
	end

	it "should save a valid clue" do
		expect(@clue).to be_valid
	end

	it "should not save a clue with missing required fields" do
		required_fields = [:hint , :question, :answer]
		required_fields.each do |field|
			invalid_clue = @clue.clone
			invalid_clue.send("#{field}=", nil)
			expect(invalid_clue).to_not be_valid
		end
	end

  it "should have a game history field" do
    expect{@clue.game_history}.to_not raise_error
  end
end
