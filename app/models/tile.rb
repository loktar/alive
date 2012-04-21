class Tile
  LIFE_PER_PLANT = 0.04
  POSSIBLE_POINTS = (0..20).map do |x|
    (0..20).map do |y|
      {x: x / 20.0, y: y / 20.0}
    end
  end.flatten

  attr_accessor :x, :y,
    :plants,
    :herbivores,
    :carnivores,
    :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize
    self.plants = []
    self.herbivores = []
    self.carnivores = []
    @remaining_life_points = POSSIBLE_POINTS.dup
    @remaining_creature_points = POSSIBLE_POINTS.dup
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
    add_or_remove_random_points(plants, desired_number_of_plants, @remaining_life_points) {
      Plant.new(available_point(@remaining_life_points))
    }

    life_amount
  end

  def life_amount
    plants.count * LIFE_PER_PLANT
  end

  def herbivore_count=(value)
    add_or_remove_random_points(herbivores, value, @remaining_creature_points) do
      Herbivore.new(available_point(@remaining_creature_points))
    end
    herbivore_count
  end

  def herbivore_count
    herbivores.count
  end

  def carnivore_count=(value)
    add_or_remove_random_points(carnivores, value, @remaining_creature_points) do
      Carnivore.new(available_point(@remaining_creature_points))
    end
    carnivore_count
  end

  def carnivore_count
    carnivores.count
  end

  def add_or_remove_random_points(array, desired_count, remaining_points, *block)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each { array << yield }
    else
      (0...delta.abs).each do
        old = array.shift
        remaining_points << { x: old.x, y: old.y }
      end
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
    index = Random.rand(array.size)

    array.delete_at(index)
  end
end
