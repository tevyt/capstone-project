class ChangeCluesDiscoverdToDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :clues, :discovered, :boolean, default: false
  end
end
