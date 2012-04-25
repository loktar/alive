class Herbivore < Entity
  include Hunger
  max_age 12
  eats meal_size: 0.4, food_type: :plant
end
