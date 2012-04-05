class World
  WORLD_SIZE = 20

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
        tile = Tile.new
        tile.x = x
        tile.y = y
        tile.life_amount = starting_life_amount_for_tile(tile)

        row << tile
      end
    end

    rows
  end

  def assign_adjacent_tiles(rows)
    rows.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        tile.top_tile     = rows[y - 1].try(:[], x)
        tile.bottom_tile  = rows[y + 1].try(:[], x)
        tile.left_tile    = rows[y].try(:[], x - 1)
        tile.right_tile   = rows[y].try(:[], x + 1)
      end
    end
  end

  def life_amount_with_probability(probability)
    (Random.rand <= probability) ? 0.1 : 0
  end

  def update_life
    foo = all_tiles
    foo.each do |tile|
      if tile.has_life?
        update_life_on_living_tile(tile)

        tile.adjacent_tiles.each do |adjacent_tile|
          spread_life_to_adjacent_tile(adjacent_tile)
        end
      end
    end
  end

  def starting_life_amount_for_tile(tile)
    if Random.rand < 0.3
      tile.life_amount = Random.rand 0.6
    else
      tile.life_amount = 0
    end
  end

  def update_life_on_living_tile(tile)
    tile.life_amount = [tile.life_amount + 0.05, 1].min
  end

  def spread_life_to_adjacent_tile(tile)
    unless tile.has_life?
      tile.life_amount = life_amount_with_probability(0.1)
    end
  end

  def all_tiles
    @rows.flatten
  end

  def to_s
    "#<#{self.class}:#{object_id} with #{all_tiles.count} tiles>"
  end

end