class Carnivore < Entity
  attr_accessor :hunger_count
  max_age 18

  def initialize(attrs={})
    super(attrs)
    @hunger_count = 0
  end

  def hungry?
    hunger_count > 5
  end

  def eat
    if hungry?
      self.hunger_count = 0
    else
      self.hunger_count = self.hunger_count + 1
    end
  end

end
