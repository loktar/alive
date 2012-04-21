module CarnivoreHelper
  CARNIVORE_MEAL_SIZE = 1
  CHANCE_TO_SPAWN_CARNIVORE = 0.2

  def self.eat_with_tile(tile)
    starve_with_tile(tile)
    consume_food_with_tile(tile)
    grow_old_with_tile(tile)
    reproduce_with_tile(tile)
  end

  def self.grow_old_with_tile(tile)
    tile.carnivores.each do |carny|
      if carny.grow_older_and_die
        tile.kill_entity_by_id(carny.id)
      end
    end
  end

  def self.starve_with_tile(tile)
    desired_food = desired_food_for_tile(tile)
    available_food = available_food_for_tile(tile)
    #puts "carnivores want to eat #{desired_food} and there is #{available_food} available from #{tile.herbivore_count} herbivores"
    if available_food < desired_food
      food_deficit = desired_food - available_food
      animals_to_starve = (1.0 * food_deficit / CARNIVORE_MEAL_SIZE).floor
      #puts "#{animals_to_starve} carnivores will starve"
      tile.carnivore_count = [tile.carnivore_count - animals_to_starve, 0].max
    end
  end

  def self.consume_food_with_tile(tile)
    old = tile.herbivore_count
    tile.herbivore_count = [tile.herbivore_count - desired_food_for_tile(tile), 0].max

    tile.carnivores.each { |c| c.eat }
    #puts "Consume herbivores from #{old} to #{tile.herbivore_count}"
  end

  def self.reproduce_with_tile(tile)
    if tile.herbivore_count > 3 && Random.rand < CHANCE_TO_SPAWN_CARNIVORE
      tile.carnivore_count = tile.carnivore_count + 1
    end
  end

  def self.desired_food_for_tile(tile)
    hungry_carnivores_for_tile(tile) * CARNIVORE_MEAL_SIZE
  end

  def self.hungry_carnivores_for_tile(tile)
    tile.carnivores.select { |c| c.hungry? }.count
  end

  def self.available_food_for_tile(tile)
    tile.herbivore_count * CARNIVORE_MEAL_SIZE
  end

end
