module HerbivoreHelper
  def self.eat_with_tile(tile)
    tile.starve(Herbivore)
    tile.consume_food_for(Herbivore)
    tile.grow_older(Herbivore)
    reproduce_with_tile(tile)
  end

  def self.reproduce_with_tile(tile)
    if tile.plant_density > 0.5
      if tile.herbivore_count < 4 && Random.rand < 0.3
        tile.herbivore_count = tile.herbivore_count + 1
      else
        tile.herbivore_count = tile.herbivore_count + Random.rand(tile.herbivore_count / 2)
      end
    end
  end
end
