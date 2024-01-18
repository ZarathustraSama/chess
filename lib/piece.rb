# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  def initialize(position, color)
    @position = position
    @initial_position = position
    @color = color
  end

  def move(position, move)
    [position[0] + move[0], position[1] + move[1]]
  end

  def check_possible_moves(position, moves)
    moves.map { |move| move(position, move) }
  end
end
