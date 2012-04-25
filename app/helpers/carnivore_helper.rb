module CarnivoreHelper
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
    desired_food = tile.desired_food_for(Carnivore)
    available_food = tile.available_food_for(Carnivore)
    #puts "carnivores want to eat #{desired_food} and there is #{available_food} available from #{tile.herbivore_count} herbivores"
    if available_food < desired_food
      food_deficit = desired_food - available_food
      animals_to_starve = (1.0 * food_deficit / Carnivore.meal_size).floor
      #puts "#{animals_to_starve} carnivores will starve"
      tile.carnivore_count = [tile.carnivore_count - animals_to_starve, 0].max
    end
  end

  def self.consume_food_with_tile(tile)
    old = tile.herbivore_count
    tile.herbivore_count = [tile.herbivore_count - tile.desired_food_for(Carnivore), 0].max

    tile.carnivores.each { |c| c.eat }
    #puts "Consume herbivores from #{old} to #{tile.herbivore_count}"
  end

  def self.reproduce_with_tile(tile)
    if tile.herbivore_count > 3 && Random.rand < CHANCE_TO_SPAWN_CARNIVORE
      tile.carnivore_count = tile.carnivore_count + 1
    end
  end
end
