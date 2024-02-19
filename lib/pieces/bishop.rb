# frozen_string_literal: true

require_relative './piece'

# The bishop piece
class Bishop < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265D" : "\u2657"
  end

  def generate_legal_moves(board)
    @moves = bishop_moves(board)
  end

  def bishop_moves(board)
    first_quadrant(board) + second_quadrant(board) + third_quadrant(board) + fourth_quadrant(board)
  end

  def first_quadrant(board)
    create_moves(board, [-1, 1])
  end

  def second_quadrant(board)
    create_moves(board, [-1, -1])
  end

  def third_quadrant(board)
    create_moves(board, [1, -1])
  end

  def fourth_quadrant(board)
    create_moves(board, [1, 1])
  end
end
