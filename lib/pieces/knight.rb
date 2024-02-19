# frozen_string_literal: true

require_relative './piece'

# The knight piece
class Knight < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265E" : "\u2658"
  end

  def generate_legal_moves(board)
    m = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
    @moves = m.map do |move|
      move(move) if board.inside?(move(move)) && (board.empty?(move(move)) || board.color?(move(move)) != @color)
    end.compact
  end
end
