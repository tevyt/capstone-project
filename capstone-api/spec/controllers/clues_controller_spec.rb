require 'rails_helper'

RSpec.describe CluesController, type: :controller do
    before(:each) do
      @clue = Clue.new(hint: 'Test', question: 'Test', answer: 'Test')
    end
    describe 'GET index' do
      it "assigns @clues" do
        @clue.save
        get :index
        expect(assigns :clues).to eq([@clue])
      end
    end
end
