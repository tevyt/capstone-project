class CluesController < ApplicationController
    before_action :set_clue , only: [:show , :update, :destroy]
    def index
      @clues = Clue.all
      render json: @clues
    end

    def show
      render json: @clue
    end

    def create
      @clue = Clue.new(clue_params)
      if @clue.save
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
      @clue = Clue.where(id:params[:id]).take
      error_message(:not_found) unless @clue
    end

    def clue_params
      params.require(:clue).permit(:hint , :question , :answer)
    end
end
