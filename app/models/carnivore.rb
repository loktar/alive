class Carnivore < Entity
  include Entities::Hunger
  include Entities::Movement
  include Entities::Reproduction
  ages max_age: 20
  eats turns_before_hungry: 6, food_type: :herbivore
  moves 2
  reproduces minimum_food: 3, add_one_until: 4, age_of_consent: 6
end
