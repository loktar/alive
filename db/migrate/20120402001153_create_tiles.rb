class CreateTiles < ActiveRecord::Migration
  def up
    create_table :tiles do |t|
      t.integer :x
      t.integer :y
      t.timestamps
    end
  end

  def down
    drop_table :tiles
  end
end
