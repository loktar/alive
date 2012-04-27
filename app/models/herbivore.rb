class Herbivore < Entity
  include Hunger
  include Movement
  max_age 12
  eats food_type: :plant, turns_before_hungry: 1
  moves 1
end
