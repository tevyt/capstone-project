require 'rails_helper'

RSpec.describe CluesController, type: :controller do
    before(:each) do
      @clue_params= {hint: 'Test', question: 'Test', answer: 'Test'}
      @clue = Clue.new(@clue_params)
      @creator = User.create(firstname: 'Creator', lastname: 'Ofgame', email: 'creator@game.com', password: 'password123')
      @game = Game.create(name: 'Test', start_time: 3.minutes.from_now)
      @game.creator = @creator
      @game.save
      request.headers['Authorization'] = "Token token=#{@creator.auth_token}"
    end

    describe 'GET index' do
      it "assigns @clues" do
        @game.clues << @clue
        get :index, {game_id: @game.id, id: @clue.id}
        expect(assigns :clues).to eq([@clue])
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET show' do
      it "assigns @clue" do
        @game.clues << @clue
        get :show, game_id: @game.id, id: @clue.id
        expect(assigns :clue).to eq(@clue)
        expect(response).to have_http_status(:ok)
      end
      it "should return 404 on show" do
        get :show, game_id: 0, id: 0
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "POST create" do
      it "should create clue" do
        post :create, game_id: @game.id, clue: @clue_params
        expect(response).to have_http_status(:created)
        expect(Clue.count).to eq(1)
      end
      it "should not create clue" do
        post :create, game_id: @game.id, clue: {question: nil}
        expect(response).to have_http_status(:bad_request)
      end
    end

    describe 'PATCH update' do
      it 'should update clue' do
        @game.clues << @clue
        patch :update, game_id: @game.id, id: @clue.id, clue: {question: 'UpdatedTitle'}
        @clue.reload
        expect(@clue.question).to eq('UpdatedTitle')
        expect(response).to have_http_status(:ok)
      end
      it 'should return 404 for non-existent clues' do
        patch :update , game_id: @game.id, id: 0, clue: {question: 'UpdatedTitle'}
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'DELETE destroy' do
      it 'should destroy a clue' do
        @game.clues << @clue
        delete :destroy, game_id: @game.id, id: @clue.id
        expect(Clue.count).to eq (0)
        expect(response).to have_http_status(:no_content)
      end
      it 'should return 404 for non-existent clues' do
        delete :destroy , game_id: @game.id, id: 1
        expect(response).to have_http_status(:not_found)
      end
    end
end
