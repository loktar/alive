module HerbivoreHelper
  def self.eat_with_tile(tile)
    tile.starve(Herbivore)
    tile.consume_food_for(Herbivore)
    tile.grow_older(Herbivore)
    tile.reproduce(Herbivore)
    move_with_tile(tile)
  end

  def self.move_with_tile(tile)
    tile.herbivores.each(&:move_within_tile)
  end
end
