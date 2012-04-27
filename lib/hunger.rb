module Hunger
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      eats food_type: :plant
    end
  end

  def eat
    if hungry?
      @hunger_count = 0
    else
      @hunger_count = hunger_count + 1
    end
  end

  def hungry?
    hunger_count >= self.class.class_variable_get(:@@turns_before_hungry)
  end

  def hunger_count
    @hunger_count ||= 0
  end

  module ClassMethods
    def eats(options={})
      self.class_variable_set(:@@turns_before_hungry, options[:turns_before_hungry] || 0)
      self.class_variable_set(:@@meal_size, options[:meal_size] || 1)

      food_type = options[:food_type].to_sym
      food_types = [:plant, :herbivore, :carnivore]
      raise "invalid food_type #{food_type}, must be one of #{food_types.join(', ')}" unless food_types.include?(food_type)
      self.class_variable_set(:@@food_type, food_type)
    end

    def meal_size
      self.class_variable_get(:@@meal_size)
    end

    def food_type
      self.class_variable_get(:@@food_type)
    end
  end
end
