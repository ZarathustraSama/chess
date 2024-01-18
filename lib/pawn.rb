# frozen_string_literal: true

require_relative './piece'

class Pawn<Piece
  def initialize
    super
    @move = [0, 1]
    @s_move = [0, 2]
    @capture_move = [1, 1]
  end
end
