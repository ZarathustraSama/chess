# frozen_string_literal: true

require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

EMPTY = nil
WHITE = 'White'
BLACK = 'Black'

PIECES = {
  w_king: '\u2654',
  w_queen: '\u2655',
  w_rook: '\u2656',
  w_bishop: '\u2657',
  w_knight: '\u2658',
  w_pawn: '\u2659',
  b_king: '\u265A',
  b_queen: '\u265B',
  b_rook: '\u265C',
  b_bishop: '\u265D',
  b_knight: '\u265E',
  b_pawn: '\u265F'
}.freeze

# The chess board
# Every component that only "snapshots" the board's status, is here
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) { EMPTY } }
  end

  def populate_board
    add_kings
    add_queens
    add_bishops
    add_knights
    add_rooks
    add_pawns
  end

  def game_over?(color)
    mate?(color) || stalemate?(color)
  end

  def mate?(color)
    check?(color) && find_all_legal_moves(color).none?
  end

  def check?(color)
    opposite_color = color == WHITE ? BLACK : WHITE
    simulate_all_positions(find_same_pieces(opposite_color)).include?(find_king(color))
  end

  def stalemate?(color)
    !check?(color) && find_all_legal_moves(color).none?
  end

  def empty?(position)
    @board[position[0]][position[1]] == EMPTY
  end

  def inside?(position)
    position[0] >= 0 && position[0] < 8 && position[1] >= 0 && position[1] < 8
  end

  def draw_board
    @board.each { |_row| draw_row }
  end

  private

  def add_kings
    add('King', [0, 4], 'Black', PIECES[:b_king])
    add('King', [7, 4], 'White', PIECES[:w_king])
  end

  def add_queens
    add('Queen', [0, 3], 'Black', PIECES[:b_queen])
    add('Queen', [7, 3], 'White', PIECES[:w_queen])
  end

  def add_bishops
    add('Bishop', [0, 2], 'Black', PIECES[:b_bishop])
    add('Bishop', [0, 5], 'Black', PIECES[:b_bishop])
    add('Bishop', [7, 2], 'White', PIECES[:w_bishop])
    add('Bishop', [7, 5], 'White', PIECES[:w_bishop])
  end

  def add_knights
    add('Knight', [0, 1], 'Black', PIECES[:b_knight])
    add('Knight', [0, 6], 'Black', PIECES[:b_knight])
    add('Knight', [7, 1], 'White', PIECES[:w_knight])
    add('Knight', [7, 6], 'White', PIECES[:w_knight])
  end

  def add_rooks
    add('Rook', [0, 0], 'Black', PIECES[:b_rook])
    add('Rook', [0, 7], 'Black', PIECES[:b_rook])
    add('Rook', [7, 0], 'White', PIECES[:w_rook])
    add('Rook', [7, 7], 'White', PIECES[:w_rook])
  end

  def add_pawns
    [*0..7].map { |i| add('Pawn', [1, i], 'Black', PIECES[:b_pawn]) }
    [*0..7].map { |i| add('Pawn', [6, i], 'White', PIECES[:w_pawn]) }
  end

  def add(piece, position, color)
    @board[position[0]][position[1]] = Object.const_get(piece).new(position, color)
  end

  def find_king(color)
    @board.flatten.compact.select { |piece| piece.instance_of?(::King) && piece.color == color }.first.position
  end

  def find_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def simulate_all_positions(pieces)
    pieces.map { |piece| piece.simulate_all_moves(pieces.moves) }.flatten(1)
  end

  def find_all_legal_moves(color)
    find_pieces(color).map do |piece|
      check_legal_moves(piece)
    end
  end

  def check_legal_moves(piece)
    find_moves(piece).select do |move|
      fake_board = Board.new
      fake_board.board = @board.map(&:dup)
      fake_board.move_piece(piece, move)
      move unless fake_board.check?(color)
    end
  end

  def find_moves(piece)
    case piece
    when instance_of?(::Rook)
      piece.create_rook_moves(@board)
    when instance_of?(::Bishop)
      piece.create_bishop_moves(@board)
    when instance_of?(::Queen)
      piece.create_queen_moves(@board)
    when instance_of?(::Pawn)
      piece.create_moves
    else
      piece.moves
    end
  end

  def draw_row; end
end
