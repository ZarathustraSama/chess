# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :initial_position, :symbol
  attr_accessor :position

  def initialize(position, color, symbol)
    @position = position
    @initial_position = position
    @color = color
    @symbol = symbol
  end

  def move(move)
    [@position[0] + move[0], @position[1] + move[1]]
  end

  def simulate_all_moves(moves)
    moves.map do |move|
      move(move)
    end
  end
end
