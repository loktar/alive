class Herbivore < Entity
  include Entities::Hunger
  include Entities::Movement
  include Entities::Reproduction
  ages max_age: 12
  eats food_type: :plant, turns_before_hungry: 1
  moves 1
  reproduces chance_to_spawn: 0.3, minimum_food: 10, add_one_until: 4, age_of_consent: 4
end
