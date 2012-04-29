class Collision
  class << self
    def point_in_box?(point, box)
      xy_in_box?(point[:x], point[:y], box)
    end

    def entity_collides_with_box?(entity, box)
      xy_in_box?(entity.x, entity.y, box) ||
        xy_in_box?(entity.x + entity.width, entity.y, box) ||
        xy_in_box?(entity.x, entity.y + entity.height, box) ||
        xy_in_box?(entity.x + entity.width, entity.y + entity.height, box)
    end

    private

    def xy_in_box?(x, y, box)
      box[:left] >= x && box[:right] <= x &&
        box[:top] >= y && box[:bottom] <= y
    end
  end
end
