# frozen_string_literal: true

require_relative './piece'

# The pawn piece
class Pawn < Piece
  attr_accessor :move, :s_move, :capture_move

  def initialize(*args)
    super
    @moves = []
  end

  def create_moves
    @moves = @color == 'White' ? generate_w_moves : generate_b_moves
  end

  def create_w_legal_moves
    moves = [[-1, 0], [-1, -1], [-1, 1]]
    moves << [-2, 0] if @position == @initial_position
    moves
  end

  def create_w_capture_moves
    [[-1, -1], [-1, 1]]
  end

  def create_b_legal_moves
    moves = [[1, 0], [1, 1], [1, -1]]
    moves << [2, 0] if @position == @initial_position
    moves
  end

  def create_b_capture_moves
    [[1, 1], [1, -1]]
  end

  def promotable?
    (@color == 'White' && @position[0].zero?) || (@color == 'Black' && @position[0] == 7)
  end
end
