class WorldsController < ApplicationController

  def index
    @world_exists = Tile.count > 0
  end

  def create
    WorldGenerator.new.generate_world
    redirect_to worlds_path
  end

end