# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  def initialize(position)
    @position = position
    @initial_position = position
  end

  def move(position, move)
    @position = [position[0] + move[0], position[1] + move[1]]
  end
end
