# frozen_string_literal: true

module Moves
  def rook_moves(board)
    vertical_positive(board) + vertical_negative(board) + horizontal_positive(board) + horizontal_negative(board)
  end

  def bishop_moves(board)
    first_quadrant(board) + second_quadrant(board) + third_quadrant(board) + fourth_quadrant(board)
  end

  def queen_moves(board)
    rook_moves(board) + bishop_moves(board)
  end

  private

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

  def create_moves(board, move)
    next_p = move(move)
    moves = []
    while board.inside?(next_p) && board.empty?(next_p)
      moves << next_p
      next_p = move(move, next_p)
    end
    moves << next_p if board.inside?(next_p) && board.board[next_p[0]][next_p[1]].color != @color
    moves
  end
end
