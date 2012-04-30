class World
  WORLD_SIZE = 10

  def self.instance
    @@world ||= generate_new_world
  end

  def self.generate_new_world
    @@world = World.new
  end

  def self.instance_exists?
    self.class_variable_defined? :@@world
  end

  def initialize
    puts "Creating new world instance..."
    @rows = create_tiles
    assign_adjacent_tiles(@rows)
    puts "done!"
  end

  def create_tiles
    rows = []
    (0...WORLD_SIZE).each do |y|
      row = []
      rows << row
      (0...WORLD_SIZE).each do |x|
        tile = Tile.new({x: x, y: y})

        row << tile
      end
    end

    rows
  end

  def assign_adjacent_tiles(rows)
    rows.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        tile.top_tile = rows[y - 1].try(:[], x)
        tile.bottom_tile = rows[y + 1].try(:[], x)
        tile.left_tile = rows[y].try(:[], x - 1)
        tile.right_tile = rows[y].try(:[], x + 1)
      end
    end
  end

  def update_life
    all_tiles.each(&:process_turn)
  end

  def all_tiles
    @rows.flatten
  end

  def kill_entity_by_id(entity_id)
    all_tiles.each { |tile| tile.kill_entity_by_id(entity_id) }
  end

  def plant_count
    all_tiles.map { |tile| tile.plants.count }.inject { |a, b| a + b }
  end

  def herbivore_count
    all_tiles.map { |tile| tile.herbivore_count }.inject { |a, b| a + b }
  end

  def carnivore_count
    all_tiles.map { |tile| tile.carnivore_count }.inject { |a, b| a + b }
  end

  def to_s
    "#<#{self.class}:#{object_id} with #{all_tiles.count} tiles>"
  end

  def as_json(options={})
    {
            tiles: all_tiles
    }
  end

end
