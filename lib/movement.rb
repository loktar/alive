module Movement
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      moves 0
    end
  end

  def move_within_tile
    possible_move = available_moves.try(:sample)
    if possible_move.present? && tile.point_available_for(possible_move, self)
      tile.move_entity(self, possible_move)
    end
  end

  def max_range
    self.class.class_variable_get(:@@max_range)
  end

  def available_moves
    return nil if max_range == 0

    ([x - max_range, 0].max..[x + max_range, tile.width].min).map do |possible_x|
      ([y - max_range, 0].max..[y + max_range, tile.height].min).map do |possible_y|
        Point.new(x: possible_x, y: possible_y)
      end
    end.flatten
  end

  module ClassMethods
    def moves(range)
      self.class_variable_set(:@@max_range, range)
    end
  end
end
