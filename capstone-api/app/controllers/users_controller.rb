class UsersController < ApplicationController
  before_action :set_user , only: [:show , :update, :destroy, :games, :created_games, :tokens]
  before_action :authenticate, only: [:register_token]
  
  def index
    @users = User.all
    render json: @users.to_json(except: :auth_token)
  end

  def show
    render json: @user.to_json(except: :auth_token)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user , status: :created
    else
      error_message(:bad_request, @user.errors)
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

  def login
    @user = User.find_by(email: params[:email])
    if @user and @user.authenticate(params[:password])
      render json: @user, status: :ok
    else
      error_message(:bad_request, error: 'Invalid Login Credentials')
    end
  end

  def register_token
    token = Token.new(token: params[:token])
    current_user.tokens << token
    if token.persisted?
      message = "New Device added"
      GcmWorker.perform_async(message: message, tokens: token)
    else
      error_message(:bad_request)
    end
  end
  
  def games
    ids = GameHistory.where(user_id: @user.id).map{|history| history.game_id}
    @games = Game.where(id: ids)
    render json: {message: @games}
  end
  
  def created_games
    render json: {message: @user.games}
  end

  def tokens
    render json: @user.tokens
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
