# frozen_string_literal: true

require_relative './piece'
require_relative './moves'

# The rook piece
class Rook < Piece
  include Moves

  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265C" : "\u2656"
  end

  def generate_legal_moves(board)
    @moves = Moves::rook_moves(board)
  end
end
