class CluesController < ApplicationController
  before_action :set_clue , only: [:show , :update, :destroy]
  before_action :set_game , only: [:index, :create] 

  def index
    @clues = @game.clues
    render json: @clues
  end

  def show
    render json: @clue
  end

  def create
    @clue = Clue.new(clue_params)
    if @game.clues << @clue
      render json: @clue, status: :created
    else
      error_message(:bad_request , @clue.errors)
    end
  end

  def update
    if @clue.update(clue_params)
      render json: @clue, status: :ok
    else
      error_message(:bad_request , @clue.errors)
    end
  end

  def destroy
    @clue.destroy
    head :no_content
  end


  protected
    def set_clue
      @clue = Clue.where(game_id: params[:game_id], id: params[:id]).take
      error_message(:not_found) unless @clue
    end

    def set_game
      @game = Game.where(params[:game_id]).take
      error_message(:not_found) unless @game
    end

    def clue_params
      params.require(:clue).permit(:hint , :question , :answer)
    end
end
