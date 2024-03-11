# frozen_string_literal: true

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

EMPTY = nil
WHITE = 'White'
BLACK = 'Black'

# The chess board
class Board
  attr_accessor :board, :double_step_pawn

  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY } }
    @double_step_pawn = nil
  end

  # Contains methods for putting all the pieces in their respective initial positions
  def populate_board
    add_kings
    add_queens
    add_bishops
    add_knights
    add_rooks
    add_pawns
  end

  # After finding all present pieces on the board, calls for the shared method for generating moves
  def update_moves(color)
    find_pieces(color).each { |piece| piece.generate_legal_moves(self) }
  end

  # The game is over if there is a checkmate or a stalemate
  def game_over?(color)
    mate?(color) || stalemate?(color)
  end

  # A checkmate occurs when the king is in check and the player has no legal moves left
  def mate?(color)
    check?(color) && !legal_moves_left?(color)
  end

  # A check is when a piece on the opponent board threatens the king with one of their possible movements
  def check?(color)
    opponent_color = color == WHITE ? BLACK : WHITE
    simulate_capture_positions(opponent_color).flatten(1).include?(find_king_position(color))
  end

  # A stalemate occurs when there is no check, but every other move performed triggers one
  def stalemate?(color)
    !check?(color) && !legal_moves_left?(color)
  end

  # Simple method to see if a square is empty or not
  def empty?(position)
    @board[position[0]][position[1]] == EMPTY
  end

  # If there is a piece in this position of the board, returns its color
  def color?(position)
    @board[position[0]][position[1]].color unless empty?(position)
  end

  # Basic method to check the board's borders
  def inside?(position)
    position[0] >= 0 && position[0] < 8 && position[1] >= 0 && position[1] < 8
  end

  # This method is at the core of many others
  # It creates an object to add to the board
  # When called at the beginning of the game, defaults the piece as having not moved
  def add(piece, position, color, moved = false, moves = [])
    @board[position[0]][position[1]] = Object.const_get(piece).new(position, color, moved, moves)
  end

  # This method first check if the piece is a pawn or a king
  # This way, special moves like castling and en-passante are properly executed
  # Then it empties the original square of the piece and calls #add to place the new instance of
  # the piece in the new square
  # When called here, #add sets the piece as having moved
  def move_piece(piece, position)
    special_move(piece, position)
    @board[piece.position[0]][piece.position[1]] = EMPTY
    add(piece.class.name, position, piece.color, true)
  end

  # Returns a fake board where the piece has been moved
  def simulate_new_board(piece, move)
    b = Marshal.load(Marshal.dump(self))
    b.move_piece(piece, move)
    b
  end

  # Returns the piece for the corresponding position on the board
  def piece(position)
    @board[position[0]][position[1]]
  end

  # Returns all the pieces present on the board
  def find_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  private

  # Calls #add to place the queen pieces
  def add_queens
    add('Queen', [0, 3], 'Black')
    add('Queen', [7, 3], 'White')
  end

  # Calls #add to place the king pieces
  def add_kings
    add('King', [0, 4], 'Black')
    add('King', [7, 4], 'White')
  end

  # Calls #add to place the rook pieces
  def add_rooks
    add('Rook', [0, 0], 'Black')
    add('Rook', [0, 7], 'Black')
    add('Rook', [7, 0], 'White')
    add('Rook', [7, 7], 'White')
  end

  # Calls #add to place the bishop pieces
  def add_bishops
    add('Bishop', [0, 2], 'Black')
    add('Bishop', [0, 5], 'Black')
    add('Bishop', [7, 2], 'White')
    add('Bishop', [7, 5], 'White')
  end

  # Calls #add to place the knight pieces
  def add_knights
    add('Knight', [0, 1], 'Black')
    add('Knight', [0, 6], 'Black')
    add('Knight', [7, 1], 'White')
    add('Knight', [7, 6], 'White')
  end

  # Calls #add to place the pawn pieces
  def add_pawns
    [*0..7].map { |i| add('Pawn', [1, i], 'Black') }
    [*0..7].map { |i| add('Pawn', [6, i], 'White') }
  end

  # Returns the position of the king of the specified color
  def find_king_position(color)
    @board.flatten.compact.select { |piece| piece.instance_of?(::King) && piece.color == color }.first.position
  end

  # Returns an array with all possible "check-zones"
  def simulate_capture_positions(color)
    find_pieces(color).map do |piece|
      if piece.instance_of?(::Pawn) || piece.instance_of?(::King)
        piece.generate_c_moves(self)
      else
        piece.generate_legal_moves(self)
      end
    end
  end

  # Checks if there are any moves left for the relative player
  def legal_moves_left?(color)
    find_pieces(color).each do |piece|
      piece.moves.compact.each do |move|
        return true unless simulate_new_board(piece, move).check?(color)
      end
    end
    false
  end

  # Checks if the piece is a pawn or a king
  # Then performs the special move if the conditions are met
  def special_move(piece, position)
    if piece.instance_of?(::Pawn)
      capture_en_passante(piece, position) if position == piece.en_passante(self)
    elsif piece.instance_of?(::King)
      if position == piece.short_castling && piece.short_castling?(self)
        short_castling(piece)
      elsif position == piece.long_castling && piece.long_castling?(self)
        long_castling(piece)
      end
    end
  end

  # When the en-passante is performed, the pawn behind is captured (a.k.a. the square becomes empty)
  def capture_en_passante(pawn, position)
    pawn.color == BLACK ? @board[position[0] - 1][position[1]] = EMPTY : @board[position[0] + 1][position[1]] = EMPTY
  end

  # When castling is performed, moves the relative rook the corresponding position
  def short_castling(king)
    king.color == BLACK ? move_piece(find_piece([0, 7]), [0, 5]) : move_piece(find_piece([7, 7]), [7, 5])
  end

  # When castling is performed, moves the relative rook the corresponding position
  def long_castling(king)
    king.color == BLACK ? move_piece(find_piece([0, 0]), [0, 2]) : move_piece(find_piece([7, 0]), [7, 2])
  end
end
