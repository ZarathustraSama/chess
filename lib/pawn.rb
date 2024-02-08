# frozen_string_literal: true

require_relative './piece'

WHITE_STEPS = [[-1, 0], [-2, 0]].freeze
WHITE_CAPTURES = [[-1, -1], [-1, 1]].freeze
BLACK_STEPS = [[1, 0], [2, 0]].freeze
BLACK_CAPTURES = [[1, 1], [1, -1]].freeze

# The pawn piece
class Pawn < Piece
  attr_accessor :double_step_taken

  def initialize(*args)
    super
    @double_step_taken = false
  end

  def generate_legal_moves(board)
    @moves = @color == 'White' ? w_moves(board) : b_moves(board)
  end

  def generate_c_moves(board)
    @color == 'White' ? capture(board, WHITE_CAPTURES) : capture(board, BLACK_CAPTURES)
  end

  def can_promote?
    @color == 'White' ? @position[0].zero? : @position[0] == 7
  end

  private

  def w_moves(board)
    step(board, WHITE_STEPS) + capture(board, WHITE_CAPTURES)
  end

  def b_moves(board)
    step(board, BLACK_STEPS) + capture(board, BLACK_CAPTURES)
  end

  def step(board, moves)
    m = []
    m << move(moves[0]) if board.empty?(move(moves[0]))
    m << move(moves[1]) if can_double_step? && board.empty?(move(moves[1]))
    m
  end

  def capture(board, moves)
    m = []
    moves.each do |move|
      c_square = move(move)
      m << c_square if board.inside?(c_square) && !board.empty?(c_square) && board.color?(c_square) != @color
    end
    en_passante(board, moves)
    m
  end

  def can_double_step?
    @position == @initial_position
  end

  def double_step_taken!
    @double_step_taken = true
  end

  def en_passante(board)
    # capturing pawn has advanced 3 ranks
    return unless advanced_3_ranks?

    # pawn-to-be-captured has made a double step next to such pawn
    # capture chance is only the turn immediately to this double step
    if can_en_passante?(board[@position[0]][@position[1] + 1])
      @color == BLACK ? move([1, 1]) : move([-1, 1])
    elsif can_en_passante?(board[@position[0]][@position[1] - 1])
      @color == BLACK ? move([1, -1]) : move([-1, -1])
    end
  end

  def can_en_passante?(square)
    square.instance_of?(::Pawn) && square&.double_step_taken
  end

  def advanced_3_ranks?
    (@position[0] - @initial_position[0]) == (-3 || 3)
  end
end
