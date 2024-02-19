# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  attr_reader :color, :initial_position, :symbol
  attr_accessor :position, :moves, :moved

  def initialize(position, color, moved, moves)
    @position = position
    @color = color
    @moved = false
    @moves = moves
    @symbol = nil
  end

  def move(move, position = @position)
    [position[0] + move[0], position[1] + move[1]]
  end

  def moved!
    @moved = true
  end

  def legal_move?(move, player)
    @moves.compact.include?(move) && @color == player
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
end
