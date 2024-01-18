# frozen_string_literal: true

EMPTY = nil

# require_relative './pawn'
# require_relative './rook'
# require_relative './knight'
# require_relative './bishop'
# require_relative './queen'
# require_relative './king'

# The chess board
class Board
  def initialize
    @board = initial_state
  end


  private

  def initial_state
    # After all pieces are created, add them here
  end

  def create_board
    Array.new(8) { Array.new(8) { EMPTY } }
  end
end
