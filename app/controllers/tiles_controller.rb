class TilesController < ApplicationController

  def index
    world = World.instance
    puts "found world #{world}"
    world.update_life
    puts "updated life"

    respond_to do |format|
      format.html { render :index }
      format.json { render json: world.all_tiles }
    end
  end

end