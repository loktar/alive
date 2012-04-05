class DropTiles < ActiveRecord::Migration
  def up
    drop_table :tiles
  end

  def down
    raise "This migration cannot be undone"
  end
end
