class AddRadiusToGames < ActiveRecord::Migration
  def change
    add_column :games, :radius, :integer, default: 1
  end
end
