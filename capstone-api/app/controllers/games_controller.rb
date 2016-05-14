class GamesController < ApplicationController
  before_action :set_game, except: [:index, :create]
  before_action :authenticate, only: [:create, :update, :destroy, :join, :quit, :discover]

  def index
    @games = Game.all
    if params[:available]
      authenticate
      @user = current_user
      @games = @games.select {|game| !game.players.include?(@user) and !game.active? and game.clues.empty?}
    end
    render json: @games
  end

  def show
    render json: @game
  end

  def create
    @game = Game.new(game_params)
    @game.creator = current_user
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
    @game.users << current_user unless @game.users.include?(current_user)
    render json: {message: 'You have been added to this game'}
  end

  def quit
    @game.users.delete current_user
    render json: {message: 'You have quit this game'}
  end

  def discover
    @clue = Clue.find(params[:clue_id])
    render json: {errors: {error: 'You have not joined that game'}}, status: :unauthorized unless @game.players.include?(current_user)
    render json: {errors: {error: 'This clue has already been discovered'}}, status: :bad_request if @clue.discovered?
    @clue.discover(current_user)
  end

  def score_board
    if @game.active?
      render json: @game.score_board
    else
      render json: {errors: {error: 'This game is not active'}}, status: :bad_request unless @game.active
    end
  end

  def players
    render json: @game.players
  end

  protected
  def set_game
    @game = Game.where(id: params[:id]).take
    error_message(:not_found) unless @game
  end

  def game_params
    params.require(:game).permit(:name, :description, :radius, :start_time, :end_time)
  end

end
