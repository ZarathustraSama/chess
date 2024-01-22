# frozen_string_literal: true

require_relative './pawn'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './queen'
require_relative './king'

EMPTY = nil

# The chess board
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

  def check?(enemy, ally)
    simulate_all_positions(find_same_pieces(enemy)).include?(find_king(ally))
  end

  def game_over?(enemy, ally)
    mate?(enemy, ally) || stalemate?(enemy, ally)
  end

  def mate?(enemy, ally)
    check?(enemy, ally) && !legal_moves_left?(ally)
  end

  def stalemate?(enemy, ally)
    !check?(enemy, ally) && !legal_moves_left?(ally)
  end

  def empty?(position)
    @board[position[0]][position[1]] == EMPTY
  end

  def inside?(position)
    position[0] >= 0 && position[0] <= 7 && position[1] >= 0 && position[1] <= 7
  end

  def update_rqb_moves
    @board.flatten.compact.each do |piece|
      if piece.class.name == 'Rook'
        piece.moves = piece.create_rook_moves
      elsif piece.class.name == 'Bishop'
        piece.moves = piece.create_bishop_moves
      elsif piece.class.name == 'Queen'
        piece.moves = piece.create_queen_moves
      end
    end
  end

  def move_piece(piece, move)
    old_position = piece.position
    new_position = piece.move(old_position, move)
    @board[old_position[0]][old_position[1]] = EMPTY
    @board[new_position[0]][new_position[1]] = piece
  end

  def castle(king, rook)
    castling_possible?(king, rook)
    king.position == king.initial_position && rook.position == rook.initial_position
  end

  def promotion_possible?(pawn)
    pawn.color == 'White' ? pawn.position[0] == 0 : pawn.position[0] == 7
  end

  def promote(pawn, piece)
    @board[pawn.position[0]][pawn.position[1]] = Object.const_get(piece).new(pawn.position, pawn.color)
  end

  private

  def add_kings
    add('King', [0, 4], 'Black')
    add('King', [7, 4], 'White')
  end

  def add_queens
    add('Queen', [0, 3], 'Black')
    add('Queen', [7, 3], 'White')
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

  def add_rooks
    add('Rook', [0, 0], 'Black')
    add('Rook', [0, 7], 'Black')
    add('Rook', [7, 0], 'White')
    add('Rook', [7, 7], 'White')
  end

  def add_pawns
    [*0..7].map { |i| add('Pawn', [1, i], 'Black') }
    [*0..7].map { |i| add('Pawn', [6, i], 'White') }
  end

  def add(piece, position, color)
    @board[position[0]][position[1]] = Object.const_get(piece).new(position, color)
  end

  def find_king(color)
    @board.flatten.compact.select { |piece| piece.class.name == 'King' && piece.color == color}.first.position
  end

  def find_same_pieces(color)
    @board.flatten.compact.select { |piece| piece.color == color }
  end

  def simulate_all_positions(pieces)
    pieces.map {|piece| make_fake_moves(piece) }.flatten(1)
  end

  def make_fake_moves(piece)
    piece.moves.map { |move| piece.move(piece.position, move) }
  end

  def legal_moves_left?(color)
    return true unless find_legal_moves(color).empty?
    false
  end

  def find_legal_moves(color)
    legal_moves = []
    ally = color
    enemy = ally == 'White' ? 'Black' : 'White'
    find_same_pieces(color).map do |piece|
      piece.moves.map do |move|
        fake_board = Board.new
        fake_board.board = @board.map(&:dup)
        fake_board.move_piece(piece, move)
        legal_moves << move unless fake_board.check?(enemy, ally)
      end
    end
    legal_moves
  end
end
