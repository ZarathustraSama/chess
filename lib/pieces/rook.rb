# frozen_string_literal: true

require_relative './piece'

# The rook piece
class Rook < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265C" : "\u2656"
  end

  def generate_legal_moves(board)
    @moves = rook_moves(board)
  end

  def rook_moves(board)
    vertical_positive(board) + vertical_negative(board) + horizontal_positive(board) + horizontal_negative(board)
  end

  def vertical_positive(board)
    create_moves(board, [-1, 0])
  end

  def vertical_negative(board)
    create_moves(board, [1, 0])
  end

  def horizontal_positive(board)
    create_moves(board, [0, 1])
  end

  def horizontal_negative(board)
    create_moves(board, [0, -1])
  end
end
