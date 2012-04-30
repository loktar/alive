module Tiles
  module LifeManagement
    def self.included(base)
      base.extend(ClassMethods)
      %w(Plant Herbivore Carnivore).each do |life_class_name|
        list_accessor = "#{life_class_name.downcase}s"
        count_accessor = "#{life_class_name.downcase}_count"

        base.class_eval <<-RUBY
          def #{list_accessor}
            @#{list_accessor} ||= []
          end

          def #{count_accessor}
            #{list_accessor}.count
          end

          def #{count_accessor}=(value)
            add_or_remove_life(#{list_accessor}, value.floor) do |point|
              #{life_class_name}.new(point: point, tile: self)
            end

            #{list_accessor}
          end
        RUBY
      end
    end

    def life_of_type(life_class)
      send("#{life_class.name.downcase}s")
    end

    def set_life_count(life_class, new_count)
      send("#{life_class.name.downcase}_count=", new_count)
    end

    def process_turn
      if has_life?
        grow_and_spread
      end

      self.class.class_variable_get(:@@animal_types).each do |animal_type|
        animal_class = animal_type.to_s.camelcase.constantize
        if animal_class.respond_to?(:eats)
          starve animal_class
          consume_food_for animal_class
        end
        grow_older animal_class if animal_class.respond_to?(:ages)
        reproduce animal_class if animal_class.respond_to?(:reproduces)
        life_of_type(animal_class).each(&:move_within_tile) if animal_class.respond_to?(:moves)
      end
    end

    module ClassMethods
      def animal_types(arr=nil)
        self.class_variable_set(:@@animal_types, arr || [])
      end
    end

    private

    def add_or_remove_life(array, desired_count)
      delta = desired_count - array.count
      if delta > 0
        (0...delta).each do
          life = nil
          begin
            life = yield(possible_points.sample)
          end while array.any? { |entity| entity.collides_with?(life.bounding_box) }

          array << life
        end
      else
        (0...delta.abs).each { array.shift }
      end
    end
  end
end
