class Point < Hash

  def initialize(point)
    self.merge!(point)
  end

  def ==(other_point)
    self[:x] == other_point[:x] && self[:y] == other_point[:y]
  end

  def in_box?(box)
    box[:left] >= self[:x] && box[:right] <= self[:x] &&
      box[:top] >= self[:y] && box[:bottom] <= self[:y]
  end

  def x
    self[:x]
  end

  def y
    self[:y]
  end
end
