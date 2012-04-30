class Tile
  include Food

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
    add_or_remove_random_points(plants, value.floor) do |point|
      Plant.new(point: point, tile: self)
    end

    plant_count
  end

  def plant_count
    plants.count
  end

  def herbivore_count=(value)
    add_or_remove_random_points(herbivores, value) do |point|
      Herbivore.new(point: point, tile: self)
    end
    herbivore_count
  end

  def herbivore_count
    herbivores.count
  end

  def carnivore_count=(value)
    add_or_remove_random_points(carnivores, value) do |point|
      Carnivore.new(point: point, tile: self)
    end
    carnivore_count
  end

  def carnivore_count
    carnivores.count
  end

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def grow_older(animal_class)
    ids_to_kill = send("#{animal_class.name.downcase}s").select(&:grow_older_and_die).map(&:id)
    ids_to_kill.each { |animal_id| kill_entity_by_id(animal_id) }
  end

  def point_available_for(point, entity)
    animals_of_type(entity.class).none? { |ent| ent.collides_with?(entity.bounding_box(point)) }
  end

  def as_json(options={ })
    {
      x: x,
      y: y,
      width: width,
      height: height,
      plants: plants,
      herbivores: herbivores,
      carnivores: carnivores,
    }
  end

  def width
    WIDTH
  end

  def height
    HEIGHT
  end

  def to_s
    inspect
  end

  def move_entity(entity, new_location)
    entity.point = new_location
  end

  def reproduce(animal_class)
    if food_count_for(animal_class) > animal_class.minimum_food
      animal_count = animals_of_type(animal_class).count
      if animal_class.add_one_until > 0 && animal_count >= animal_class.add_one_until
        set_life_count(animal_class, animal_count + Random.rand(animal_count / 2))
      elsif Random.rand < animal_class.chance_to_spawn
        set_life_count(animal_class, animal_count + 1)
      end
    end
  end

  protected

  def grow
    self.plant_count = [plant_count + 2, MAXIMUM_PLANTS].min
  end

  private

  def set_life_count(animal_class, new_count)
    send("#{animal_class.name.downcase}_count=", new_count)
  end

  def seed_plants
    self.plant_count = Random.rand < 0.3 ? Random.rand(12) : 0
  end

  def add_or_remove_random_points(array, desired_count)
    delta = desired_count - array.count
    if delta > 0
      (0...delta).each do
        life = nil
        begin
          life = yield(POSSIBLE_POINTS.sample)
        end while array.any? { |entity| entity.collides_with?(life.bounding_box) }

        array << life
      end
    else
      (0...delta.abs).each { array.shift }
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
