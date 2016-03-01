class CreateClues < ActiveRecord::Migration
  def change
    create_table :clues do |t|
      t.text :hint
      t.text :question
      t.text :answer
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
