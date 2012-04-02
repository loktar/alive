class TilesController < ApplicationController

  def index
    respond_to do |format|
      format.html { render :index }
      format.json { render json: Tile.all }
    end
  end

end