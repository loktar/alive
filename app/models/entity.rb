class Entity
  include Entities::Aging

  @@entity_count = 0

  def self.next_id
    @@entity_count = @@entity_count + 1
  end

  attr_accessor :id,
    :point,
    :width, :height,
    :overlapped_points,
    :tile

  def initialize(attrs={ })
    @id = self.class.next_id
    @point = attrs[:point]
    @tile = attrs[:tile]
    @width = @height = 2
    @overlapped_points = []
  end

  def x
    point.x
  end

  def y
    point.y
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
    Collision.entity_collides_with_box?(self, other_box)
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
