# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :moved, :symbol
  attr_accessor :position, :moves

  def initialize(position, color, moved, moves)
    @position = position
    @color = color
    @moved = moved
    @moves = moves
    @symbol = nil
  end

  def move(move, position = @position)
    [position[0] + move[0], position[1] + move[1]]
  end

  def legal_move?(move, player)
    @moves.compact.include?(move) && @color == player
  end
end
