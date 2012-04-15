module Aging
  def self.included(base)
    base.extend(ClassMethods)
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
    def max_age(age)
      self.class_variable_set(:@@max_age, age)
    end
  end
end
