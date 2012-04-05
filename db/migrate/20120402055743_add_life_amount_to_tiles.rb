class AddLifeAmountToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :life_amount, :decimal
  end
end
