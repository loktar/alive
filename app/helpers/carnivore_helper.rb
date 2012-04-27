module CarnivoreHelper
  CHANCE_TO_SPAWN_CARNIVORE = 0.2

  def self.eat_with_tile(tile)
    tile.starve(Carnivore)
    tile.consume_food_for(Carnivore)
    tile.grow_older(Carnivore)
    reproduce_with_tile(tile)
    move_with_tile(tile)
  end

  def self.reproduce_with_tile(tile)
    if tile.herbivore_count > 3 && Random.rand < CHANCE_TO_SPAWN_CARNIVORE
      tile.carnivore_count = tile.carnivore_count + 1
    end
  end

  def self.move_with_tile(tile)
    tile.carnivores.each(&:move_within_tile)
  end
end
