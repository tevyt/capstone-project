require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before(:each) do
    @game_params = {name: 'Test Game' , radius: 1, start_time: 3.minutes.from_now}
    @game = Game.new(@game_params)
    @user = User.create(firstname: 'Travis', lastname: 'Smith', email: 'email@email.com', password: 'pazzword')
    request.headers['Authorization'] = "Token token=#{@user.auth_token}"
  end

  describe 'GET index' do
    it 'assigns @games' do
      @game.save
      get :index
      expect(assigns :games).to eq([@game])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    it 'assigns @game' do
      @game.save
      get :show , id: @game.id
      expect(assigns :game).to eq(@game)
      expect(response).to have_http_status(:ok)
    end

    it 'should return a 404 for non-existent games' do
      get :show, id: 1
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST create' do
    it 'should create a game' do
      post :create , game: @game_params
      expect(Game.count).to eq(1)
      expect(response).to have_http_status(:created)
      @new_game = Game.find(response_body['id'])
      expect(@new_game.creator).to eq(@user)
    end

    it 'should return a bad request for an invalid game' do
      post :create, game: {radius: 'A radius of course is not sufficient'}
      expect(response).to have_http_status(:bad_request)
      expect(Game.count).to eq(0)
    end
  end

  describe 'PATCH update' do
    it 'should update a game' do
      @game.creator = @user
      @game.save
      patch :update, id: @game.id, game: {radius: 20}
      @game.reload
      expect(@game.radius).to eq(20)
      expect(response).to have_http_status(:ok)
    end

    it 'should return bad request if params are invalid' do
      @game.creator = @user
      @game.save
      patch :update, id: @game.id, game: {name: ''}
      expect(response).to have_http_status(:bad_request)
    end

    it 'should return 404 for non-existent user' do
      patch :update, id: 1, game: {radius: 20}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH join' do
    it 'should allow a user to join a game' do
      @game.save
      patch :join, id: @game.id
      expect(response).to have_http_status(:ok)
      expect(response_body['message']).to eq('You have been added to this game')
      expect(@game.reload.users.size).to eq(1)
    end

    it 'should not add a user to a game twice' do
      @game.save
      @game.users << @user
      patch :join, id: @game.id
      expect(response).to have_http_status(:ok)
      expect(@game.users.size).to eq(1)
    end

    it 'should allow a second user to be added' do
      @game.save
      @game.users << @user
      second_user = User.create(firstname: 'Second', lastname: 'User', email: 'second@user.com', password: 'password1234')
      request.headers['Authorization'] = "Token token=#{second_user.auth_token}"
      patch :join, id: @game.id
      expect(response).to have_http_status(:ok)
      expect(@game.users.size).to eq(2)
    end
  end

  describe "DELETE quit" do
    it "should allow a user to quit a game" do
      @game.save
      @game.users << @user
      delete :quit, id: @game
      expect(response).to have_http_status(:ok)
      expect(@game.users.size).to eq(0)
    end
  end

end
