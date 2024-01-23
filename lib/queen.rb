# frozen_string_literal: true

require_relative './piece'
require_relative './move'

# The queen piece
class Queen < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end

  def queen_moves(board)
    m = Move.new
    m.x_moves(board) + m.y_moves(board) + m.positive_xy_moves(board) + m.negative_xy_moves(board)
  end
end
