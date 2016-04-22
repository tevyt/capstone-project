class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy, :join]
  before_action :authenticate, only: [:create, :update, :destroy, :join]

  def index 
    @games = Game.all
    render json: @games
  end

  def show
    render json: @game
  end

  def create
    @game = Game.new(game_params)
    @game.creator = @current_user
    if @game.save 
      render json: @game, status: :created
    else
      error_message(:bad_request, @game.errors)
    end
  end

  def update
    return error_message(:unauthorized) unless authorized?(@game.creator)
    if @game.update(game_params)
      render json: @game
    else
      error_message(:bad_request, @game.errors)
    end
  end

  def join
    @game.users << @current_user unless @game.users.include?(@current_user) 
    render json: {message: 'You have been added to this game'}
  end

  protected
  def set_game
    @game = Game.where(id: params[:id]).take
    error_message(:not_found) unless @game
  end

  def game_params
    params.require(:game).permit(:name, :radius, :start_time)
  end

end
