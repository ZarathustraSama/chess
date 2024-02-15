# frozen_string_literal: true

require_relative './piece'

# The queen piece
class Queen < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u2655" : "\u265B"
  end

  # A necessary repetition from the bishop/rook classes in order to avoid object creations
  def generate_legal_moves(board)
    @moves = queen_moves(board)
  end

  def queen_moves(board)
    rook_moves(board) + bishop_moves(board)
  end

  def bishop_moves(board)
    first_quadrant(board) + second_quadrant(board) + third_quadrant(board) + fourth_quadrant(board)
  end

  def rook_moves(board)
    vertical_positive(board) + vertical_negative(board) + horizontal_positive(board) + horizontal_negative(board)
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
