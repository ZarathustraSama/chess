# frozen_string_literal: true

require_relative './piece'

# The king piece
class King < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ?  "\u265A" : "\u2654"
  end

  def generate_legal_moves(board)
    @moves = generate_c_moves(board)
    @moves << short_castling if short_castling?(board)
    @moves << long_castling if long_castling?(board)
    @moves
  end

  def generate_c_moves(board)
    m = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [-1, 1], [1, -1]]
    m.map do |move|
      move(move) if board.inside?(move(move)) && (board.empty?(move(move)) || board.color?(move(move)) != @color)
    end
  end

  def short_castling
    @color == BLACK ? [0, 6] : [7, 6]
  end

  def long_castling
    @color == BLACK ? [0, 1] : [7, 1]
  end

  def short_castling?(board)
    rook = @color == BLACK ? board.board[0][7] : board.board[7][7]
    squares = @color == BLACK ? [[0, 5], [0, 6]] : [[7, 5], [7, 6]]
    return false unless rook.instance_of?(::Rook)

    castling?(board, rook, squares)
  end

  def long_castling?(board)
    # same as above, just one extra square to check
    rook = @color == BLACK ? board.board[0][0] : board.board[7][0]
    squares = @color == BLACK ? [[0, 3], [0, 2], [0, 1]] : [[7, 3], [7, 2], [7, 1]]
    return false unless rook.instance_of?(::Rook)

    castling?(board, rook, squares)
  end

  def castling?(board, rook, squares)
    # king/rook hasn't moved king is not in check
    return false if @moved || rook.moved || board.check?(@color)

    # squares between are not "check-zones" nor empty
    b = Marshal.load(Marshal.dump(board))
    squares.each do |move|
      return false unless board.empty?(move)

      b.move_piece(self, move)
      return false if b.check?(@color)
    end
    true
  end
end
