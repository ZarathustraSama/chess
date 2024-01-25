# frozen_string_literal: true

require_relative './board'

# This is where interaction of the pieces and changes to the board takes place
class Game
  attr_accessor :board

  def initialize
    @board = Board.new.populate_board
  end

  def update_rqb_moves
    get_pieces.each do |piece|
      case piece
      when instance_of?(::Rook)
        piece.moves = piece.create_rook_moves(@board)
      when instance_of?(::Bishop)
        piece.moves = piece.create_bishop_moves(@board)
      when instance_of?(::Queen)
        piece.moves = piece.create_queen_moves(@board)
      end
    end
  end

  def move_piece(piece, move)
    from = piece.position
    to = piece.move(old_position, move)
    @board.board[from[0]][from[1]] = EMPTY
    @board.board[to[0]][to[1]] = piece
  end

  def castle(king, rook)
    castling_possible?(king, rook)
    king.position == king.initial_position && rook.position == rook.initial_position
  end

  def promote(pawn, piece)
    @board.board[pawn.position[0]][pawn.position[1]] = Object.const_get(piece).new(pawn.position, pawn.color)
  end
end
