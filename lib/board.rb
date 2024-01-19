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

  def find_king(color)
    @board.flatten.compact.select { |piece| piece.class.name == 'King' && piece.color == color}.first.position
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
end
