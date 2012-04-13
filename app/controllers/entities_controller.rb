class EntitiesController < ApplicationController

  def destroy
    World.instance.kill_entity_by_id(params[:id].to_i)

    head :ok
  end

end