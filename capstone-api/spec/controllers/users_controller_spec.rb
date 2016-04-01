require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    @user = User.new(email: 'test@test.com', password: '1234567890', firstname: 'Test' , lastname: 'Test')
  end
  describe 'GET index' do
    it "assigns @users" do
      @user.save
      get :index
      expect(assigns :users).to eq([@user])
    end
  end
end
