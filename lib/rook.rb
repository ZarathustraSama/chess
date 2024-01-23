# frozen_string_literal: true

require_relative './piece'
require_relative '.move'

# The rook piece
class Rook < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end

  def rook_moves(board)
    m = Move.new
    m.x_moves(board) + m.y_moves(board)
  end
end
