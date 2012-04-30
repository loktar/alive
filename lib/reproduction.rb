module Reproduction
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      reproduces
    end
  end

  module ClassMethods
    def reproduces(options={})
      self.class_variable_set(:@@chance_to_spawn, options[:chance_to_spawn] || 0.2)
      self.class_variable_set(:@@minimum_food, options[:minimum_food] || 1)
      self.class_variable_set(:@@add_one_until, options[:add_one_until] || 0)
    end

    def minimum_food
      self.class_variable_get(:@@minimum_food)
    end

    def add_one_until
      self.class_variable_get(:@@add_one_until)
    end

    def chance_to_spawn
      self.class_variable_get(:@@chance_to_spawn)
    end
  end
end
