module Entities
  module Aging
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        ages
      end
    end

    def age
      @age || 0
    end

    def age=(value)
      @age = value
    end

    def old?
      old_age > 0 && age > old_age
    end

    def grow_older_and_die
      self.age = age + 1
      old? && Random.rand < 0.2
    end

    def old_age
      self.class.class_variable_get(:@@max_age)
    end

    module ClassMethods
      def ages(options={})
        self.class_variable_set(:@@max_age, options[:max_age] || 0)
      end
    end
  end
end
