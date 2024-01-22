# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :initial_position
  attr_accessor :position

  def initialize(position, color)
    @position = position
    @initial_position = position
    @color = color
  end

  def move(position, move)
    [position[0] + move[0], position[1] + move[1]]
  end
end
