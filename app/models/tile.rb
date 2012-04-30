class Tile
  include Tiles::Food
  include Tiles::LifeManagement
  animal_types [:herbivore, :carnivore]

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
    :left_tile, :top_tile, :right_tile, :bottom_tile

  def initialize(attrs={ })
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

  def adjacent_tiles
    [left_tile, right_tile, bottom_tile, top_tile].compact
  end

  def grow_older(animal_class)
    ids_to_kill = send("#{animal_class.name.downcase}s").select(&:grow_older_and_die).map(&:id)
    ids_to_kill.each { |animal_id| kill_entity_by_id(animal_id) }
  end

  def point_available_for(point, entity)
    life_of_type(entity.class).none? { |ent| ent.collides_with?(entity.bounding_box(point)) }
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
      animal_count = life_of_type(animal_class).count
      if animal_class.add_one_until > 0 && animal_count >= animal_class.add_one_until
        old_enough_count = life_of_type(animal_class).select(&:can_reproduce?).count
        set_life_count(animal_class, animal_count + Random.rand(old_enough_count / 2))
      elsif Random.rand < animal_class.chance_to_spawn
        set_life_count(animal_class, animal_count + 1)
      end
    end
  end

  protected

  def grow
    self.plant_count = [plant_count + 1, MAXIMUM_PLANTS].min
  end

  private

  def seed_plants
    self.plant_count = Random.rand < 0.3 ? Random.rand(12) : 0
  end

  def spread_life_to_adjacent_tile(tile)
    if plant_density > 0.9
      if tile.has_life?
        tile.grow
      else
        tile.plant_count = 1
      end
    elsif plant_density > 0.5
      tile.plant_count = [tile.plant_count + plant_count_with_probability(0.2), MAXIMUM_PLANTS].min
    elsif !tile.has_life?
      tile.plant_count = plant_count_with_probability(0.1)
    end
  end

  def plant_count_with_probability(probability)
    (Random.rand < probability) ? 1 : 0
  end

  def possible_points
    POSSIBLE_POINTS
  end
end
