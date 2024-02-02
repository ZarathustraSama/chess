# frozen_string_literal: true

require_relative './piece'

# The knight piece
class Knight < Piece
  def generate_legal_moves(board)
    m = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
    @moves = m.map { |move| move(move) if board.inside?(move(move)) && board.empty?(move(move)) }.compact
  end
end
