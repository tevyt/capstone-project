class ChangeGameHistoryScoreToDefaultToZero < ActiveRecord::Migration
  def change
    change_column :game_histories, :score, :integer, default: 0
  end
end
