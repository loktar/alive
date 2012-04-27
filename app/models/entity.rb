class Entity
  include Aging

  @@entity_count = 0

  def self.next_id
    @@entity_count = @@entity_count + 1
  end

  attr_accessor :id,
    :x, :y,
    :width, :height,
    :overlapped_points,
    :tile

  def initialize(attrs={ })
    @id = self.class.next_id
    @x = attrs[:x]
    @y = attrs[:y]
    @tile = attrs[:tile]
    @width = @height = 2
    @overlapped_points = []
  end

  def bounding_box(point=nil)
    the_x = point.try(:x) || x
    the_y = point.try(:y) || y
    {
      top: the_y,
      right: the_x + width,
      bottom: the_y + height,
      left: the_x
    }
  end

  def collides_with?(other_box)
    corners.any? { |corner| corner.in_box?(other_box) }
  end

  def corners
    [
      Point.new({ x: x, y: y }),
      Point.new({ x: x + width, y: y }),
      Point.new({ x: x, y: y + height }),
      Point.new({ x: x + width, y: y + height })
    ]
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
