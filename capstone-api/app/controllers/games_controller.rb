class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy]

  def index 
    @games = Game.all
    render json: @games
  end

  def show
    render json: @game
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      render json: @game, status: :created
    else
      error_message(:bad_request, @game.errors)
    end
  end

  def update
    if @game.update(game_params)
      render json: @game
    else
      error_message(:bad_request, @game.errors)
    end
  end


  protected
  def set_game
    @game = Game.where(id: params[:id]).take
    error_message(:not_found) unless @game
  end

  def game_params
    params.require(:game).permit(:name, :radius)
  end

end
