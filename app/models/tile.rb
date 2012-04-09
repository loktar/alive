class Tile
  attr_accessor :x, :y,
                :life_amount, :herbivore_count,
                :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize
    self.life_amount = 0
    self.herbivore_count = 0
  end

  def has_life?
    self.life_amount > 0
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def as_json(options={})
    {
            x: x,
            y: y,
            life_amount: life_amount.round(3),
            herbivore_count: herbivore_count,
    }
  end

  def to_s
    "#<#{self.class}:#{object_id} x:#{x} y:#{y} life_amount:#{life_amount}>"
  end

end