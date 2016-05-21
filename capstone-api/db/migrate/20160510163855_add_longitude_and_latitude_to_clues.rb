class AddLongitudeAndLatitudeToClues < ActiveRecord::Migration
  def change
    add_column :clues, :longitude, :float
    add_column :clues, :latitude, :float
  end
end
