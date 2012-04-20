class WorldsController < ApplicationController

  def create
    World.generate_new_world
    head :ok
  end

  def current
    world = World.instance
    world.update_life
    render json: world
  end

end
