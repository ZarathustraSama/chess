# frozen_string_literal: true

require_relative './piece'
require_relative '.move'

# The bishop piece
class Bishop < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end

  def bishop_moves(board)
    m = Move.new
    m.positive_xy_moves(board) + m.negative_xy_moves(board)
  end
end
