module Tiles
  module LifeManagement
    def self.included(base)
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
