class AddClueToCoordinates < ActiveRecord::Migration
  def change
    add_reference :coordinates, :clue, index: true, foreign_key: true
  end
end
