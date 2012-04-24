module HerbivoreHelper
  HERBIVORE_MEAL_SIZE = 0.4

  def self.eat_with_tile(tile)
    starve_with_tile(tile)
    consume_food_with_tile(tile)
    grow_old_with_tile(tile)
    reproduce_with_tile(tile)
  end

  def self.grow_old_with_tile(tile)
    tile.herbivores.each do |herby|
      if herby.grow_older_and_die
        tile.kill_entity_by_id(herby.id)
      end
    end
  end

  def self.starve_with_tile(tile)
    desired_food = tile.herbivore_count * HERBIVORE_MEAL_SIZE
    #puts "herbivores want to eat #{desired_food} and there are #{tile.herbivore_count} of them"
    if tile.plant_count < desired_food
      food_deficit = desired_food - tile.plant_count
      animals_to_starve = (1.0 * food_deficit / HERBIVORE_MEAL_SIZE).floor
      #puts "#{animals_to_starve} will starve"
      tile.herbivore_count = [tile.herbivore_count - animals_to_starve, 0].max
    end
  end

  def self.consume_food_with_tile(tile)
    tile.plant_count = [tile.plant_count - (tile.herbivore_count * HERBIVORE_MEAL_SIZE), 0].max
  end

  def self.reproduce_with_tile(tile)
    if tile.plant_density > 0.5
      if tile.herbivore_count < 4 && Random.rand < 0.3
        tile.herbivore_count = tile.herbivore_count + 1
      else
        tile.herbivore_count = tile.herbivore_count + Random.rand(tile.herbivore_count / 2)
      end
      #puts "new herbivore count: #{tile.herbivore_count}"
    else
      #puts "not adding herbivores"
    end
  end

end
