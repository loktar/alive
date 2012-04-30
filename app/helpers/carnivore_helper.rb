module CarnivoreHelper
  def self.eat_with_tile(tile)
    tile.starve(Carnivore)
    tile.consume_food_for(Carnivore)
    tile.grow_older(Carnivore)
    tile.reproduce(Carnivore)
    move_with_tile(tile)
  end

  def self.move_with_tile(tile)
    tile.carnivores.each(&:move_within_tile)
  end
end
