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
# Every component that only "snapshots" the board's status, is here
class Board
  attr_accessor :board, :double_step_pawn

  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY } }
    @double_step_pawn = nil
  end

  def populate_board
    add_kings
    add_queens
    add_bishops
    add_knights
    add_rooks
    add_pawns
  end

  def update_moves(color)
    find_pieces(color).each { |piece| piece.generate_legal_moves(self) }
  end

  def game_over?(color)
    mate?(color) || stalemate?(color)
  end

  def mate?(color)
    check?(color) && !legal_moves_left?(color)
  end

  def check?(color)
    opponent_color = color == WHITE ? BLACK : WHITE
    simulate_capture_positions(opponent_color).flatten(1).include?(find_king_position(color))
  end

  def stalemate?(color)
    !check?(color) && !legal_moves_left?(color)
  end

  def empty?(position)
    @board[position[0]][position[1]] == EMPTY
  end

  def color?(position)
    @board[position[0]][position[1]].color unless empty?(position)
  end

  def inside?(position)
    position[0] >= 0 && position[0] < 8 && position[1] >= 0 && position[1] < 8
  end

  def add(piece, position, color, moved = false, moves = [])
    @board[position[0]][position[1]] = Object.const_get(piece).new(position, color, moved, moves)
  end

  def move_piece(piece, position)
    if piece.instance_of?(::Pawn)
      capture_en_passante(piece, position) if position == piece.en_passante(self)
    elsif piece.instance_of?(::King)
      if position == piece.short_castling && piece.short_castling?(self)
        short_castling(piece)
      elsif position == piece.long_castling && piece.long_castling?(self)
        long_castling(piece)
      end
    end
    @board[piece.position[0]][piece.position[1]] = EMPTY
    add(piece.class.name, position, piece.color, true)
  end

  def capture_en_passante(pawn, position)
    pawn.color == BLACK ? @board[position[0] - 1][position[1]] = EMPTY : @board[position[0] + 1][position[1]] = EMPTY
  end

  def short_castling(king)
    king.color == BLACK ? move_piece(find_piece([0, 7]), [0, 5]) : move_piece(find_piece([7, 7]), [7, 5])
  end

  def long_castling(king)
    king.color == BLACK ? move_piece(find_piece([0, 0]), [0, 2]) : move_piece(find_piece([7, 0]), [7, 2])
  end

  # Returns a fake board where the piece has been moved
  def simulate_new_board(piece, move)
    b = Marshal.load(Marshal.dump(self))
    b.move_piece(piece, move)
    b
  end

  def find_piece(position)
    @board[position[0]][position[1]]
  end

  def find_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  private

  def add_queens
    add('Queen', [0, 3], 'Black')
    add('Queen', [7, 3], 'White')
  end

  def add_kings
    add('King', [0, 4], 'Black')
    add('King', [7, 4], 'White')
  end

  def add_rooks
    add('Rook', [0, 0], 'Black')
    add('Rook', [0, 7], 'Black')
    add('Rook', [7, 0], 'White')
    add('Rook', [7, 7], 'White')
  end

  def add_bishops
    add('Bishop', [0, 2], 'Black')
    add('Bishop', [0, 5], 'Black')
    add('Bishop', [7, 2], 'White')
    add('Bishop', [7, 5], 'White')
  end

  def add_knights
    add('Knight', [0, 1], 'Black')
    add('Knight', [0, 6], 'Black')
    add('Knight', [7, 1], 'White')
    add('Knight', [7, 6], 'White')
  end

  def add_pawns
    [*0..7].map { |i| add('Pawn', [1, i], 'Black') }
    [*0..7].map { |i| add('Pawn', [6, i], 'White') }
  end

  def find_king_position(color)
    @board.flatten.compact.select { |piece| piece.instance_of?(::King) && piece.color == color }.first.position
  end

  def simulate_capture_positions(color)
    find_pieces(color).map do |piece|
      if piece.instance_of?(::Pawn) || piece.instance_of?(::King)
        piece.generate_c_moves(self)
      else
        piece.generate_legal_moves(self)
      end
    end
  end

  def legal_moves_left?(color)
    find_pieces(color).each do |piece|
      piece.moves.each do |move|
        return true unless simulate_new_board(piece, move).check?(color)
      end
    end
    false
  end
end
