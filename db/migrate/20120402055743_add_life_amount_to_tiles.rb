class AddLifeAmountToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :plant_density, :decimal
  end
end
