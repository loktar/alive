class Carnivore
  attr_accessor :x, :y, :hunger_count

  def initialize(attrs={})
    @x = attrs[:x]
    @y = attrs[:y]
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

  def as_json(options = {})
    [x, y]
  end
end