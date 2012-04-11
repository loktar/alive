class Tile
  LIFE_PER_PLANT = 0.05

  attr_accessor :x, :y,
                :life_amount, :plants,
                :herbivores,
                :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize
    self.plants = []
    self.herbivores = []
    self.life_amount = 0
  end

  def has_life?
    self.life_amount > 0
  end

  def life_amount=(value)
    @life_amount = value

    desired_number_of_plants = (life_amount / LIFE_PER_PLANT).floor
    add_or_remove_random_points(plants, desired_number_of_plants)

    life_amount
  end

  def herbivore_count=(value)
    add_or_remove_random_points(herbivores, value)

    herbivore_count
  end

  def herbivore_count
    herbivores.count
  end

  def add_or_remove_random_points(array, desired_count)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each { array << [Random.rand.round(3), Random.rand.round(3)] }
    else
      (0...delta.abs).each { array.shift }
    end
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def as_json(options={})
    {
            x: x,
            y: y,
            life_amount: life_amount.round(3),
            plants: plants,
            herbivores: herbivores
    }
  end

  def to_s
    "#<#{self.class}:#{object_id} x:#{x} y:#{y} life_amount:#{life_amount}>"
  end

end