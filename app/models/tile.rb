class Tile
  LIFE_PER_PLANT = 0.04
  AVAILABLE_POINTS = [
    { x: 0, y: 0 }, { x: 0.2, y: 0 }, { x: 0.4, y: 0 }, { x: 0.6, y: 0 }, { x: 0.8, y: 0 },
      { x: 0, y: 0.2 }, { x: 0.2, y: 0.2 }, { x: 0.4, y: 0.2 }, { x: 0.6, y: 0.2 }, { x: 0.8, y: 0.2 },
      { x: 0, y: 0.4 }, { x: 0.2, y: 0.4 }, { x: 0.4, y: 0.4 }, { x: 0.6, y: 0.4 }, { x: 0.8, y: 0.4 },
      { x: 0, y: 0.6 }, { x: 0.2, y: 0.6 }, { x: 0.4, y: 0.6 }, { x: 0.6, y: 0.6 }, { x: 0.8, y: 0.6 },
      { x: 0, y: 0.8 }, { x: 0.2, y: 0.8 }, { x: 0.4, y: 0.8 }, { x: 0.6, y: 0.8 }, { x: 0.8, y: 0.8 },
  ]

  attr_accessor :x, :y,
    :plants,
    :herbivores,
    :carnivores,
    :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize
    self.plants = []
    self.herbivores = []
    self.carnivores = []
  end

  def has_life?
    self.life_amount > 0
  end

  def kill_entity_by_id(entity_id)
    plants.delete_if { |e| e.id == entity_id }
    herbivores.delete_if { |e| e.id == entity_id }
    carnivores.delete_if { |e| e.id == entity_id }
  end

  def life_amount=(value)
    desired_number_of_plants = (value / LIFE_PER_PLANT).floor
    add_or_remove_random_points(plants, desired_number_of_plants) {
      Plant.new(available_point(plants))
    }

    life_amount
  end

  def life_amount
    plants.count * LIFE_PER_PLANT
  end

  def herbivore_count=(value)
    add_or_remove_random_points(herbivores, value) {
      Herbivore.new(available_point(herbivores))
    }
    herbivore_count
  end

  def herbivore_count
    herbivores.count
  end

  def carnivore_count=(value)
    add_or_remove_random_points(carnivores, value) {
      Carnivore.new(available_point(carnivores))
    }
    carnivore_count
  end

  def carnivore_count
    carnivores.count
  end

  def add_or_remove_random_points(array, desired_count, *block)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each { array << yield }
    else
      (0...delta.abs).each { array.shift }
    end
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def as_json(options={ })
    {
      x: x,
      y: y,
      plants: plants,
      herbivores: herbivores,
      carnivores: carnivores,
    }
  end

  def to_s
    "#<#{self.class}:#{object_id} x:#{x} y:#{y} life_amount:#{life_amount}>"
  end

  private

  def available_point(array)
    point_index = Random.rand (1 / LIFE_PER_PLANT) - array.count
    filled_points = array.map { |point| { x: point.x, y: point.y } }
    AVAILABLE_POINTS.reject { |point| filled_points.include? point }[point_index]
  end
end
