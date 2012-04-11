module HerbivoreHelper
  HERBIVORE_MEAL_SIZE = 0.05

  def self.eat_with_tile(tile)
    starve_with_tile(tile)
    consume_food_with_tile(tile)
    reproduce_with_tile(tile)
  end

  def self.starve_with_tile(tile)
    desired_food = tile.herbivore_count * HERBIVORE_MEAL_SIZE
    #puts "herbivores want to eat #{desired_food} and there are #{tile.herbivore_count} of them"
    if tile.life_amount < desired_food
      food_deficit = desired_food - tile.life_amount
      animals_to_starve = (1.0 * food_deficit / HERBIVORE_MEAL_SIZE).floor
      #puts "#{animals_to_starve} will starve"
      tile.herbivore_count = [tile.herbivore_count - animals_to_starve, 0].max
    end
  end

  def self.consume_food_with_tile(tile)
    old = tile.life_amount
    tile.life_amount = [tile.life_amount - (tile.herbivore_count * HERBIVORE_MEAL_SIZE), 0].max

    #puts "Consume from #{old} to #{tile.life_amount}"
  end

  def self.reproduce_with_tile(tile)
    #puts "life amount: #{tile.life_amount}"
    if tile.life_amount > 0.5 && Random.rand < 0.3
      tile.herbivore_count = tile.herbivore_count + 1
      #puts "new herbivore count: #{tile.herbivore_count}"
    else
      #puts "not adding herbivores"
    end
  end

end