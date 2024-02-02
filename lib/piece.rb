# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :initial_position, :symbol
  attr_accessor :position, :moves

  def initialize(position, color, symbol)
    @position = position
    @initial_position = position
    @color = color
    @symbol = symbol
    @moves = []
  end

  def move(move, position = @position)
    [position[0] + move[0], position[1] + move[1]]
  end

  # Utility method for rook, bishop and queen moves
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

  # Returns a fake board where the piece has been moved
  def simulate_new_board(board, position)
    b = Marshal.load(Marshal.dump(board))
    b.board[@position[0]][@position[1]] = nil
    b.board[position[0]][position[1]] = self
    b
  end
end
