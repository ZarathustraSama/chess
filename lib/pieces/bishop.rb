# frozen_string_literal: true

require_relative './piece'
require_relative './moves'

# The bishop piece
class Bishop < Piece
  include Moves

  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265D" : "\u2657"
  end

  def generate_legal_moves(board)
    @moves = Moves::bishop_moves(board)
  end
end
