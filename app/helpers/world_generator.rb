class WorldGenerator
  WORLD_SIZE = 2

  def generate_world
    Tile.delete_all

    (0...WORLD_SIZE).each do |x|
      (0...WORLD_SIZE).each do |y|
        Tile.create!(x: x, y: y)
      end
    end
  end
end