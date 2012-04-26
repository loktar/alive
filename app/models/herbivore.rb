class Herbivore < Entity
  include Hunger
  max_age 12
  eats food_type: :plant, turns_before_hungry: 1
end
