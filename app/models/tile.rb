class Tile
  LIFE_PER_PLANT = 0.05
  WIDTH = 20
  HEIGHT = WIDTH
  POSSIBLE_POINTS = (0..WIDTH).map do |x|
    (0..HEIGHT).map do |y|
      Point.new({ x: x, y: y })
    end
  end.flatten

  attr_accessor :x, :y,
    :plants,
    :herbivores,
    :carnivores,
    :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize(attrs={ })
    self.plants = []
    self.herbivores = []
    self.carnivores = []
    self.x = attrs[:x]
    self.y = attrs[:y]
    @remaining_life_points = POSSIBLE_POINTS.dup
    @remaining_creature_points = POSSIBLE_POINTS.dup

    seed_plants
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
    add_or_remove_random_points(plants, desired_number_of_plants, @remaining_life_points) do |point|
      Plant.new(point)
    end

    life_amount
  end

  def life_amount
    plants.count * LIFE_PER_PLANT
  end

  def herbivore_count=(value)
    add_or_remove_random_points(herbivores, value, @remaining_creature_points) do |point|
      Herbivore.new(point)
    end
    herbivore_count
  end

  def herbivore_count
    herbivores.count
  end

  def carnivore_count=(value)
    add_or_remove_random_points(carnivores, value, @remaining_creature_points) do |point|
      Carnivore.new(point)
    end
    carnivore_count
  end

  def carnivore_count
    carnivores.count
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def as_json(options={ })
    {
      x: x,
      y: y,
      width: WIDTH,
      height: HEIGHT,
      plants: plants,
      herbivores: herbivores,
      carnivores: carnivores,
    }
  end

  def to_s
    inspect
  end

  private

  def available_point(array)
    index = Random.rand(array.size)

    array.delete_at(index)
  end

  def seed_plants
    self.life_amount = Random.rand < 0.3 ? Random.rand(0.6) : 0
  end

  def add_or_remove_random_points(array, desired_count, remaining_points)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each do
        life = yield(available_point(remaining_points))
        box = life.bounding_box(WIDTH, HEIGHT)

        life.overlapped_points = remaining_points.select { |point| point.in_box?(box) }
        remaining_points.reject! { |point| point.in_box?(box) }

        array << life
      end
    else
      (0...delta.abs).each do
        old = array.shift
        remaining_points.concat(old.overlapped_points)
      end
    end
  end
end
