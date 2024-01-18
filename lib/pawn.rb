# frozen_string_literal: true

require_relative './piece'

class Pawn<Piece
  attr_accessor :move, :s_move, :capture_move

  def initialize
    super
    @move = [0, 1]
    @s_move = [0, 2]
    @capture_move = [1, 1]
  end
end
