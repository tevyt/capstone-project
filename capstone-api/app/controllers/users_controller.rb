class UsersController < ApplicationController
  before_action :set_user , only: [:show , :update, :destroy]
  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user , status: :created
    else
      error_message(:bad_request , @user.errors)
    end
  end

  def update
    if @user.update(user_params)
      render json: @user , status: :ok
    else
      error_message(:bad_request , @user.errors)
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end 
    
  protected
  def set_user
    @user = User.where(id:params[:id]).take
    error_message(:not_found) unless @user
  end

  def user_params
    params.require(:user).permit(:email , :password , :firstname, :lastname)
  end
end
