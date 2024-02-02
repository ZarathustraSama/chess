# frozen_string_literal: true

require_relative './piece'

# The king piece
class King < Piece
  def generate_legal_moves(board)
    m = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [-1, 1], [1, -1]]
    @moves = m.map { |move| move(move) if board.inside?(move(move)) && board.empty?(move(move)) }.compact
  end
end
