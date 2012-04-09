class WorldsController < ApplicationController

  def index
    @world_exists = World.instance_exists?
  end

  def create
    World.generate_new_world
    redirect_to worlds_path
  end

  def current
    world = World.instance
    world.update_life
    render json: world
  end

end