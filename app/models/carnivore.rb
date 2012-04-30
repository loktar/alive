class Carnivore < Entity
  include Entities::Hunger
  include Entities::Movement
  include Entities::Reproduction
  max_age 18
  eats turns_before_hungry: 5, food_type: :herbivore
  moves 2
  reproduces minimum_food: 3
end
