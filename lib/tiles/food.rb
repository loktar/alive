module Tiles
  module Food
    def available_food_for(animal_class)
      food_count_for(animal_class) * animal_class.meal_size
    end

    def desired_food_for(animal_class)
      life_of_type(animal_class).select(&:hungry?).count * animal_class.meal_size
    end

    def consume_food_for(animal_class)
      food_count_attr = "#{animal_class.food_type}_count"
      updated_food_count = [send(food_count_attr) - desired_food_for(animal_class), 0].max
      send("#{food_count_attr}=", updated_food_count)

      life_of_type(animal_class).each(&:eat)
    end

    def starve(animal_class)
      food_deficit = desired_food_for(animal_class) - available_food_for(animal_class)
      if food_deficit > 0
        animals_to_starve = (1.0 * food_deficit / animal_class.meal_size).floor

        count_attr = "#{animal_class.name.downcase}_count"
        send("#{count_attr}=", [send(count_attr) - animals_to_starve, 0].max)
      end
    end

    def food_count_for(animal_class)
      send("#{animal_class.food_type}_count")
    end
  end
end
