class RemoveClueIndexFromClues < ActiveRecord::Migration
  def change
    remove_index :clues, column: :previous_clue_id
  end
end
