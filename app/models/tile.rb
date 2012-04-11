class Tile
  LIFE_PER_PLANT = 0.05

  attr_accessor :x, :y,
                :life_amount, :plants,
                :herbivore_count,
                :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize
    self.plants = []
    self.life_amount = 0
    self.herbivore_count = 0
  end

  def has_life?
    self.life_amount > 0
  end

  def life_amount=(value)
    @life_amount = value

    desired_number_of_plants = (life_amount / LIFE_PER_PLANT).floor
    plant_delta = desired_number_of_plants - plants.count
    #puts "desired number of plants #{desired_number_of_plants} for life amount #{life_amount}, delta: #{plant_delta}"
    if plant_delta > 0
      (0...plant_delta).each { plants << [Random.rand.round(3), Random.rand.round(3)] }
    else
      (0...plant_delta.abs).each { plants.shift }
    end

    #puts "plant count #{plants.count}"

    life_amount
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
            herbivore_count: herbivore_count,
    }
  end

  def to_s
    "#<#{self.class}:#{object_id} x:#{x} y:#{y} life_amount:#{life_amount}>"
  end

end