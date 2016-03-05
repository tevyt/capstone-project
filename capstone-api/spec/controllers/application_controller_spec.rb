require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
	describe "POST #test" do
		context "when is successfully created" do
			before(:each) do
				@user = User.create( firstname: 'Example', lastname: 'Doe', email: 'Example@example.com' , password:"12345678")
			end
		    it "should find a valid user" do
		        post :test,{ email: @user.email, password: @user.password}
		        expect(assigns(:currentUser)).to eq @user
		    end

		    it "should not find a user that does not exist" do
		        post :test, {email: "not email" , password: "not password"}
		        expect(assigns(:currentUser)).to be_nil
		    end

			it "should not find a user that user has incorrect password" do
				post :test, {email: @user.email , password: "not password"}
		        expect(assigns(:currentUser)).to be_nil
			end
		end
	end
end
