class CreateGameHistories < ActiveRecord::Migration
  def change
    create_table :game_histories do |t|
      t.integer :score
      t.integer :rank
      t.references :game, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
