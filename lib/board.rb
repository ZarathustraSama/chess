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
  w_king: "\u2654",
  w_queen: "\u2655",
  w_rook: "\u2656",
  w_bishop: "\u2657",
  w_knight: "\u2658",
  w_pawn: "\u2659",
  b_king: "\u265A",
  b_queen: "\u265B",
  b_rook: "\u265C",
  b_bishop: "\u265D",
  b_knight: "\u265E",
  b_pawn: "\u265F"
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
    opposite_color = color == WHITE ? BLACK : WHITE
    simulate_capture_positions(opposite_color).flatten(1).include?(find_king_position(color))
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

  def move_piece(piece, position)
    @board[piece.position[0]][piece.position[1]] = EMPTY
    add(piece.class.name, position, piece.color, piece.symbol)
  end

  def draw_board
    # @board.each { |_row| draw_row }
  end

  # def repetition_of_moves_rule?
  # def 50_moves_rule?

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

  def add(piece, position, color, symbol)
    @board[position[0]][position[1]] = Object.const_get(piece).new(position, color, symbol)
  end

  def find_king_position(color)
    @board.flatten.compact.select { |piece| piece.instance_of?(::King) && piece.color == color }.first.position
  end

  def find_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def simulate_capture_positions(color)
    find_pieces(color).map do |piece|
      if piece.instance_of?(::Pawn)
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

  # Returns a fake board where the piece has been moved
  def simulate_new_board(piece, move)
    b = Marshal.load(Marshal.dump(self))
    b.move_piece(piece, move)
    b
  end

  def draw_row; end
end
