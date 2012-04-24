class Tile
  LIFE_PER_PLANT = 0.05
  MAXIMUM_PLANTS = 1 / LIFE_PER_PLANT
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
    self.plant_density > 0
  end

  def kill_entity_by_id(entity_id)
    plants.delete_if { |e| e.id == entity_id }
    herbivores.delete_if { |e| e.id == entity_id }
    carnivores.delete_if { |e| e.id == entity_id }
  end

  def grow_and_spread
    adjacent_tiles.each { |tile| spread_life_to_adjacent_tile(tile) }

    grow
  end

  def plant_density
    plant_count * LIFE_PER_PLANT
  end

  def plant_count=(value)
    add_or_remove_random_points(plants, value.floor, @remaining_life_points) do |point|
      Plant.new(point)
    end

    plant_count
  end

  def plant_count
    plants.count
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

  protected

  def grow
    self.plant_count = [plant_count + 2, MAXIMUM_PLANTS].min
  end

  private

  def available_point(array)
    index = Random.rand(array.size)

    array[index]
  end

  def seed_plants
    self.plant_count = Random.rand < 0.3 ? Random.rand(12) : 0
  end

  def add_or_remove_random_points(array, desired_count, remaining_points)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each do
        life = nil
        box = nil
        begin
          life = yield(available_point(remaining_points))
          box = life.bounding_box
        end while array.any? { |entity| entity.collides_with?(box) }

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

  def spread_life_to_adjacent_tile(tile)
    if plant_density > 0.9
      if tile.has_life?
        tile.grow
      else
        tile.plant_count = 2
      end
    elsif plant_density > 0.5
      tile.plant_count = [tile.plant_count + plant_count_with_probability(0.2), MAXIMUM_PLANTS].min
    elsif !tile.has_life?
      tile.plant_count = plant_count_with_probability(0.1)
    end
  end

  def plant_count_with_probability(probability)
    (Random.rand < probability) ? 2 : 0
  end
end
