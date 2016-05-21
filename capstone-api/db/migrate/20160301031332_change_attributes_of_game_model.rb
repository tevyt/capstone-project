class ChangeAttributesOfGameModel < ActiveRecord::Migration
  def change
		remove_column :games, :duration
		add_column :games, :start_time, :datetime
		add_column :games, :end_time, :datetime
		add_column :games, :active, :boolean, default: false
  end
end
