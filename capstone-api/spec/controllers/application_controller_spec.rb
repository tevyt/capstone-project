require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "GET #test" do

    it "should return ok when a valid token is passed" do
      @user = User.create(firstname: 'Example', lastname: 'Doe', email: 'example@example.com', password:"12345678")
      request.headers['Authorization'] = "Token token=#{@user.auth_token}"  
      get :test
      expect(response).to have_http_status(:ok)
    end

    it "should return 401 when an invalid token is passed" do
      request.headers['Authorization'] = "Token token=NOT_A_VALID_TOKEN"
      get :test
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq('Bad Credentials')
    end

    it "should return 401 if Authorization header is ommited" do
      get :test
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq('Bad Credentials')
    end
  end
end
