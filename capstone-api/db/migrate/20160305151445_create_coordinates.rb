class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end
  end
end
