# frozen_string_literal: true

require_relative './piece'
require_relative './moves'

# The queen piece
class Queen < Piece
  include Moves

  def initialize(*args)
    super
    @symbol = @color == WHITE ?  "\u265B" : "\u2655"
  end

  def generate_legal_moves(board)
    @moves = Moves::queen_moves(board)
  end
end
