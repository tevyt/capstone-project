class AddDiscoveredToClues < ActiveRecord::Migration
  def change
    add_column :clues, :discovered, :boolean
  end
end
