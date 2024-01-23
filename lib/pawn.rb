# frozen_string_literal: true

require_relative './piece'

# The pawn piece
class Pawn < Piece
  attr_accessor :move, :s_move, :capture_move

  def initialize(*args)
    super
    @normal_move = @color == 'White' ? [-1, 0] : [1, 0]
    @super_move = @color == 'White' ? [-2, 0] : [2, 0]
    # For simplicity it has the same name of the other pieces
    @moves = @color == 'White' ? [[-1, -1], [-1, 1]] : [[1, 1], [1, -1]]
  end

  def promotable?
    (@color == 'White' && @position[0].zero?) || (@color == 'Black' && @position[0] == 7)
  end
end
