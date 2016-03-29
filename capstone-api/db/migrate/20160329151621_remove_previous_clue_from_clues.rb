class RemovePreviousClueFromClues < ActiveRecord::Migration
  def change
    remove_column :clues , :previous_clue_id, :integer
  end
end
