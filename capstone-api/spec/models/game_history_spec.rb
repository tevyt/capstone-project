require 'rails_helper'

RSpec.describe GameHistory, type: :model do

  it "should associate user and game" do
    @game = Game.create(name: 'baguette', start_time: 3.minutes.from_now, end_time: 5.minutes.from_now)
    @user = User.create(firstname: 'Example', lastname: 'Trial',email: 'example@example.com',password:'12345678')
    @game.users << @user
    game_history = GameHistory.where(game_id: @game.id,user_id: @user.id).limit(1)
    expect(game_history).to be_truthy
  end
end
