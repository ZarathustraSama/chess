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

  private

  def add_kings
    add('King', [3, 0], 'Black')
    add('King', [3, 7], 'White')
  end

  def add_queens
    add('Queen', [4, 0], 'Black')
    add('Queen', [4, 7], 'White')
  end

  def add_bishops
    add('Bishop', [2, 0], 'Black')
    add('Bishop', [5, 0], 'Black')
    add('Bishop', [2, 7], 'White')
    add('Bishop', [5, 7], 'White')
  end

  def add_knights
    add('Knight', [1, 0], 'Black')
    add('Knight', [6, 0], 'Black')
    add('Knight', [1, 7], 'White')
    add('Knight', [6, 7], 'White')
  end

  def add_rooks
    add('Rook', [0, 0], 'Black')
    add('Rook', [7, 0], 'Black')
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
