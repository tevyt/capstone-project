require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  before(:each) do
    @game_params = {name: 'Test Game' , radius: 1, start_time: 3.minutes.from_now, end_time: 5.minutes.from_now}
    @game = Game.new(@game_params)
    @creator = User.create(firstname: 'Travis', lastname: 'Smith', email: 'email@email.com', password: 'pazzword')
    @player = User.create(firstname: 'Example', lastname: 'Player', email: 'email@player.com', password: 'pazzword')
    @clue = Clue.create(hint: :hint, question: :question, answer: :answer, latitude: 33, longitude: 44)
    @game.clues << @clue
    @game.creator = @creator
    request.headers['Authorization'] = "Token token=#{@creator.auth_token}"
  end

  describe 'GET index' do
    it 'assigns @games' do
      @game.save
      get :index
      expect(assigns :games).to eq([@game])
      expect(response).to have_http_status(:ok)
    end

    it 'should be able to return inactive games that a user is not a part of' do
      player2 = User.create!(firstname: 'Test', lastname: 'Test', email: 'test@test.org', password: 'I really love sentences')
      game1 = Game.create!(@game_params)
      game2 = Game.create!(@game_params)
      game3 = Game.create!(@game_params)

      game1.players << player2
      game2.players << player2
      game3.players << player2

      game2.players << @creator

      game1.update(active: false)
      game2.update!(active: false)
      game3.update!(active: true)

      clue1 = Clue.new(hint: :hint, answer: :answer, question: :question, latitude: 33, longitude: 44)   
      clue2 = Clue.new(hint: :hint, answer: :answer, question: :question, latitude: 33, longitude: 44)  
      clue3 = Clue.new(hint: :hint, answer: :answer, question: :question, latitude: 33, longitude: 44)  

      game1.clues << clue1
      game2.clues << clue2
      game3.clues << clue3

      get :index, available: true
      expect(assigns :games).to eq([game1])
      expect(assigns :user).to eq(@creator)
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
      expect(@new_game.creator).to eq(@creator)
    end

    it 'should return a bad request for an invalid game' do
      post :create, game: {radius: 'A radius of course is not sufficient'}
      expect(response).to have_http_status(:bad_request)
      expect(Game.count).to eq(0)
    end
  end

  describe 'PATCH update' do
    it 'should update a game' do
      @game.save
      patch :update, id: @game.id, game: {radius: 20}
      @game.reload
      expect(@game.radius).to eq(20)
      expect(response).to have_http_status(:ok)
    end

    it 'should return bad request if params are invalid' do
      @game.save
      patch :update, id: @game.id, game: {name: ''}
      expect(response).to have_http_status(:bad_request)
    end

    it 'should return 404 for non-existent game ' do
      patch :update, id: 1, game: {radius: 20}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PATCH join' do
    it 'should allow a user to join a game' do
      @game.save
      request.headers['Authorization'] = "Token token=#{@player.auth_token}"
      patch :join, id: @game.id
      expect(response).to have_http_status(:ok)
      expect(response_body['message']).to eq('You have been added to this game')
      expect(@game.reload.users.size).to eq(1)
    end

    it 'should not add a user to a game twice' do
      @game.save
      @game.players << @player
      request.headers['Authorization'] = "Token token=#{@player.auth_token}"
      patch :join, id: @game.id
      expect(response).to have_http_status(:ok)
      expect(@game.users.size).to eq(1)
    end

    it 'should allow a second user to be added' do
      @game.save
      @game.users << @player
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
      request.headers['Authorization'] = "Token token=#{@player.auth_token}"
      delete :quit, id: @game
      expect(response).to have_http_status(:ok)
      expect(@game.users.size).to eq(0)
    end
  end

  describe 'PATCH discover' do
    it 'should allow a user to discover a clue' do
      clue = Clue.new(hint: 'Hint', question: 'Question', answer: 'Answer', latitude: 33, longitude: 44)
      game = Game.create(name: 'This is a game', start_time: 3.days.from_now, end_time: 5.days.from_now)
      game.creator = @creator
      game.players << @player
      game.clues << clue
      request.headers['Authorization'] = "Token token=#{@player.auth_token}"
      put :discover, id: game.id, clue_id: clue.id
      expect(clue.reload).to be_discovered
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET scoreboard' do
    def create_game
      user1 = User.create!(firstname: 'Test1', lastname: 'Test2', email: 'test1@test.org',password: 'password1')
      user2 = User.create!(firstname: 'Trial', lastname: 'Trialing', email:'trial@trial.com', password:'password1')
      user3 = User.create!(firstname: 'Example', lastname: 'Exampler', email: 'example@example.com', password:'password1')
      clue1 = Clue.create!(hint: 'Hint', question: 'Question', answer: 'Answer', latitude: 33, longitude: 40)
      clue2 = Clue.create!(hint: 'Lol', question: 'Lol?', answer:'Lol', latitude: 66, longitude: 80)
      clue3 = Clue.create!(hint: 'Here', question: 'There', answer:'Where', latitude: 10, longitude: 10)
      clue4 = Clue.create!(hint: 'Look over there', question: 'Where is', answer:'There is', latitude: 20, longitude: 20)
      clue5 = Clue.create!(hint: 'You want', question:'Any way', answer:'It', latitude: 40, longitude: 40)
      game = Game.create!(name: 'A ways off', start_time: 1.year.from_now, end_time:2.years.from_now)
      creator = User.create!(firstname: 'The', lastname: 'Creator', email:'the@creator.com', password: '1234567890123')
      game.creator = creator
      game.players << [user1, user2, user3]
      game.clues = [clue1, clue2, clue3, clue4, clue5]
      game.save
      clue1.discover(user1)
      clue2.discover(user1)
      clue3.discover(user1)
      clue4.discover(user2)
      clue5.discover(user2)
      game
    end
    it 'should not get the score_board for an inactive game' do
      game = create_game
      get :score_board, id: game.id
      expect(response).to have_http_status(:bad_request)
    end

    it 'should produce a scoreboard for an active game' do
      game = create_game
      game.update_attribute(:active, true)
      get :score_board, id: game.id
      expect(response).to have_http_status :ok
      result = response_body

      user1 = User.find_by(firstname: 'Test1')
      expect(result[0]['score']).to eq(3)
      expect(result[0]['user_id']).to eq(user1.id)

      user2 = User.find_by(firstname: 'Trial')
      expect(result[1]['score']).to eq(2)
      expect(result[1]['user_id']).to eq(user2.id)

      expect(result[2]['score']).to eq(0)
    end

    describe 'GET players' do
      it 'should return a list of players in a game' do
        game = Game.create!(name: 'Test Game', start_time: 3.years.from_now, end_time: 4.years.from_now)
        user1 = User.create!(firstname: 'Thor', lastname: 'Odinson', email: 'thor@avengers.org', password: 'Mjolnir because I am worthy')
        user2 = User.create!(firstname: 'Bruce', lastname: 'Banner', email: 'hulk@avengers.org', password: 'Hulk Smash')
        game.players << [user1, user2]
        get :players, id: game.id 
        ids = response_body.map{|player| player['id'].to_i}
        expect(ids).to include(user1.id)
        expect(ids).to include(user2.id)
      end
    end
      
  end

end
