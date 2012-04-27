class Carnivore < Entity
  include Hunger
  include Movement
  max_age 18
  eats turns_before_hungry: 5, food_type: :herbivore
  moves 2
end
