class Carnivore < Entity
  include Hunger
  max_age 18
  eats turns_before_hungry: 5, food_type: :herbivore
end
