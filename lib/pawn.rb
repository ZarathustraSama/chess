# frozen_string_literal: true

require_relative './piece'

class Pawn<Piece
  attr_accessor :move, :s_move, :capture_move

  def initialize(*args)
    super
    @normal_move = [0, 1]
    @super_move = [0, 2]
    @moves = self.color == 'White' ? [[-1, -1], [-1, 1]] : [[1, 1], [1, -1]] # For simplicity it has the same name of the other pieces
  end
end
