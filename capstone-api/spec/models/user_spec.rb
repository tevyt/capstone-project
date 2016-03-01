require 'rails_helper'

RSpec.describe User, type: :model do
	before(:each) do
		@user = User.new(firstname: 'Example', lastname: 'Trial',email: 'Example@example.com' , password:"12345678")
	end

	it "should validate the presence of a first name" do
		@user.firstname = nil
		expect(@user).to_not be_valid
	end

	it "should validate the presence of a last name" do
		@user.lastname = nil
		expect(@user).to_not be_valid
	end

	it "should validate the presence of an email" do
		@user.email = nil
		expect(@user).to_not be_valid
	end

	it "should validate the presence of a password" do
		@user.password = nil
		expect(@user).to_not be_valid
	end

    it "should validate user password greater than 8 characters" do
        @user.password = "123"
        expect(@user).to_not be_valid
    end

	it "should save a valid user" do
		expect(@user).to be_valid
	end

	it "should not accept invalid emails" do
		@user.email = "asdf.com"
		expect(@user).to_not be_valid
	end

	it "should not allow user with duplicate email" do
		User.create(firstname: "Example", lastname: "Trial", email: 'Example@example.com' , password:"12345678")
		expect(@user).to_not be_valid
	end

end
