class Entity
  include Aging

  @@entity_count = 0

  def self.next_id
    @@entity_count = @@entity_count + 1
  end

  attr_accessor :id,
    :x, :y,
    :width, :height,
    :overlapped_points

  def initialize(attrs={ })
    @id = self.class.next_id
    @x = attrs[:x]
    @y = attrs[:y]
    @width = 2
    @height = 2
    @overlapped_points = []
  end

  def as_json(options = { })
    {
      id: id,
      x: x,
      y: y,
      width: width,
      height: height,
      lifeType: self.class.name.downcase,
      isOld: old?
    }
  end

end
