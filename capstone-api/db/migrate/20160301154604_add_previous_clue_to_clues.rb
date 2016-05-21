class AddPreviousClueToClues < ActiveRecord::Migration
  def change
    add_reference :clues, :previous_clue, index: true, foreign_key: true
  end
end
