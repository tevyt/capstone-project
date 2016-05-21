require 'rails_helper'

RSpec.describe Token, type: :model do
  before(:each) do
    @token = Token.new(token: 'Test')
  end

  it "should validate the presence of a token" do
    @token.token = nil
    expect(@token).to_not be_valid
  end

  it "should save a valid token" do
    expect(@token).to be_valid
  end
end
