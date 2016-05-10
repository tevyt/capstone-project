require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user_params = {email: 'test@test.com', password: '1234567890', firstname: 'Test' , lastname: 'Test'}
    @user = User.new(@user_params)
  end
  describe 'GET index' do
    it "assigns @users" do
      @user.save
      get :index
      expect(assigns :users).to eq([@user])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET show' do
    it 'assigns @user' do
      @user.save
      get :show , id: @user.id
      expect(assigns :user).to eq(@user)
      expect(response).to have_http_status(:ok)
    end

    it 'should return a 404 for non-existent users' do
      get :show, id: 1
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST create' do
    it 'should create a user' do
      post :create , user: @user_params
      expect(User.count).to eq(1)
      expect(response).to have_http_status(:created)
    end

    it 'should return a bad request for invalid params' do
      post :create , user: {email: "This ain't valid"}
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PATCH update' do
    it 'should update a user' do
      @user.save
      patch :update , id: @user.id, user: {firstname: 'New'}
      @user.reload
      expect(@user.firstname).to eq('New')
      expect(response).to have_http_status(:ok)
    end

    it 'should return a 404 for non-existent user' do
      patch :update , id: 1, user: {firstname: 'New'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE destroy' do
    it 'should destroy a user' do
      @user.save
      delete :destroy, id: @user.id
      expect(User.count).to eq (0)
      expect(response).to have_http_status(:no_content)
    end

    it 'should return 404 for non-existent users' do
      delete :destroy , id: 1
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST login' do
    it 'should allow an existing user to login' do
      @user.save
      post :login, email: @user.email, password: @user.password
      expect(response).to have_http_status(:ok)
    end

    it 'should not allow a user with invalid credentials to login' do
      @user.save
      post :login, email: @user.email, password: 'THIS COULD BE THE PASSWORD'
      expect(response).to have_http_status(:bad_request)
      errors = response_body['errors']
      expect(errors['error']).to eq('Invalid Login Credentials')
    end
  end

  describe 'POST register_token' do
    it 'should register token' do
      @user.save
      request.headers['Authorization'] = "Token token=#{@user.auth_token}"
      post :register_token, token: 'token'
      expect(response).to have_http_status(:ok)
    end
  end
  describe "GET games" do
    it 'should get all games a player is in' do
      @user.save
      player2 = User.create!(firstname: 'Test', lastname: 'STest', email: 'thisisatest@test.net', password: 'testtestestestest')
      game = Game.create!(name: 'This is a game', start_time: 3.minutes.from_now)
      game.players << @user
      game2 = game.clone
      game2.save
      game2.players << player2
      request.headers['Authorization'] = "Token token=#{@user.auth_token}"
      get :games, id: @user.id
      expect(assigns :games).to eq([game])
      expect(response).to have_http_status(:ok)
      request.headers['Authorization'] = "Token token=#{player2.auth_token}"
      get :games, id: @user.id
      expect(assigns :games).to eq([game2])
      expect(response).to have_http_status(:ok)
    end
  end
end
