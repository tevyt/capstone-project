class AddGameHistoryToClues < ActiveRecord::Migration
  def change
    add_reference :clues, :game_history, index: true, foreign_key: true
  end
end
