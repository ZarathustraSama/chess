# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :initial_position
  attr_accessor :position

  def initialize(position, color)
    @position = position
    @initial_position = position
    @color = color
  end

  def move(position, move)
    [position[0] + move[0], position[1] + move[1]]
  end

  def create_rook_moves(board)
    create_x_moves(board) + create_y_moves(board)
  end

  def create_bishop_moves(board)
    create_positive_xy_moves(board) + create_negative_xy_moves(board)
  end

  def create_queen_moves(board)
    create_rook_moves(board) + create_bishop_moves(board)
  end

  private

  def create_x_moves(board)
    create_positive_x_moves(board) + create_negative_x_moves(board)
  end

  def create_y_moves(board)
    create_positive_y_moves(board) + create_negative_y_moves(board)
  end

  def create_positive_y_moves(board)
    extend_moves(board, [-1, 0])
  end

  def create_negative_y_moves(board)
    extend_moves(board, [1, 0])
  end

  def create_positive_x_moves(board)
    extend_moves(board, [0, 1])
  end

  def create_negative_x_moves(board)
    extend_moves(board, [0, -1])
  end

  def create_positive_xy_moves(board)
    create_first_quadrant_moves(board) + create_third_quadrant_moves(board)
  end

  def create_negative_xy_moves(board)
    create_second_quadrant_moves(board) + create_fourth_quadrant_moves(board)
  end

  def create_first_quadrant_moves(board)
    extend_moves(board, [-1, 1])
  end

  def create_second_quadrant_moves(board)
    extend_moves(board, [-1, -1])
  end

  def create_third_quadrant_moves(board)
    extend_moves(board, [1, -1])
  end

  def create_fourth_quadrant_moves(board)
    extend_moves(board, [1, 1])
  end

  def extend_moves(board, move)
    moves = []
    new_position = move(@position, move)
    while board.inside?(new_position) && board.empty?(new_position)
      moves << new_position
      new_position = move(new_position, move)
    end
    moves << move(new_position, move)
    moves
  end
end
