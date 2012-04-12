class Entity
  @@entity_count = 0

  def self.next_id
    @@entity_count = @@entity_count + 1
  end

  attr_accessor :id,
                :x, :y

  def initialize(attrs={})
    @id = self.class.next_id
    @x = attrs[:x]
    @y = attrs[:y]
  end

  def as_json(options = {})
    {
            id: id,
            x: x,
            y: y,
    }
  end

end