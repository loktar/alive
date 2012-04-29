class Point < Hash

  def initialize(point)
    self.merge!(point)
  end

  def ==(other_point)
    self[:x] == other_point[:x] && self[:y] == other_point[:y]
  end

  def in_box?(box)
    Collision.point_in_box?(self, box)
  end

  def x
    self[:x]
  end

  def y
    self[:y]
  end
end
