# frozen_string_literal: true

# Utility class for rook, bishop and queen movements
class Move
  def x_moves(board)
    positive_x_moves(board) + negative_x_moves(board)
  end

  def y_moves(board)
    positive_y_moves(board) + negative_y_moves(board)
  end

  def positive_y_moves(board)
    create_moves(board, [-1, 0])
  end

  def negative_y_moves(board)
    create_moves(board, [1, 0])
  end

  def positive_x_moves(board)
    create_moves(board, [0, 1])
  end

  def negative_x_moves(board)
    create_moves(board, [0, -1])
  end

  def positive_xy_moves(board)
    first_quadrant_moves(board) + third_quadrant_moves(board)
  end

  def negative_xy_moves(board)
    second_quadrant_moves(board) + fourth_quadrant_moves(board)
  end

  def first_quadrant_moves(board)
    create_moves(board, [-1, 1])
  end

  def second_quadrant_moves(board)
    create_moves(board, [-1, -1])
  end

  def third_quadrant_moves(board)
    create_moves(board, [1, -1])
  end

  def fourth_quadrant_moves(board)
    create_moves(board, [1, 1])
  end

  def create_moves(board, position, move)
    moves = []
    new_position = move(position, move)
    while board.inside?(new_position) && board.empty?(new_position)
      moves << new_position
      new_position = move(new_position, move)
    end
    moves << move(new_position, move)
    moves
  end

  def move(position, move)
    [position[0] + move[0], position[1] + move[1]]
  end
end
