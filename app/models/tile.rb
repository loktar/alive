class Tile
  attr_accessor :x, :y, :life_amount
  attr_accessor :left_tile, :top_tile, :right_tile, :bottom_tile

  def has_life?
    life_amount > 0
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def as_json(options={})
    {
            x: x,
            y: y,
            life_amount: life_amount,
    }
  end

  def to_s
    "#<#{self.class}:#{object_id} x:#{x} y:#{y} life_amount:#{life_amount}>"
  end

end