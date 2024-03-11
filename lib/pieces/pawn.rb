# frozen_string_literal: true

require_relative './piece'

WHITE_STEPS = [[-1, 0], [-2, 0]].freeze
WHITE_CAPTURES = [[-1, -1], [-1, 1]].freeze
BLACK_STEPS = [[1, 0], [2, 0]].freeze
BLACK_CAPTURES = [[1, 1], [1, -1]].freeze

# The pawn piece
class Pawn < Piece
  def initialize(*args)
    super
    @symbol = @color == WHITE ? "\u265F" : "\u2659"
  end

  def generate_legal_moves(board)
    @moves = @color == WHITE ? w_moves(board) : b_moves(board)
  end

  def generate_c_moves(board)
    @color == WHITE ? capture(board, WHITE_CAPTURES) : capture(board, BLACK_CAPTURES)
  end

  def w_moves(board)
    step(board, WHITE_STEPS) + capture(board, WHITE_CAPTURES)
  end

  def b_moves(board)
    step(board, BLACK_STEPS) + capture(board, BLACK_CAPTURES)
  end

  def step(board, moves)
    m = []
    m << move(moves[0]) if board.empty?(move(moves[0]))
    m << move(moves[1]) if !@moved && board.empty?(move(moves[1]))
    m
  end

  def capture(board, moves)
    m = []
    moves.each do |move|
      c_square = move(move)
      m << c_square if board.inside?(c_square) && !board.empty?(c_square) && board.color?(c_square) != @color
    end
    m << en_passante(board)
    m
  end

  def en_passante(board)
    # capturing pawn has advanced 3 ranks
    return nil unless advanced_3_ranks?

    # pawn-to-be-captured has made a double step next to such pawn
    if [@position[0], @position[1] + 1] == board.double_step_pawn
      @color == BLACK ? move([1, 1]) : move([-1, 1])
    elsif [@position[0], @position[1] - 1] == board.double_step_pawn
      @color == BLACK ? move([1, -1]) : move([-1, -1])
    end
  end

  def double_step?(rank)
    @color == WHITE ? rank == 4 : rank == 3
  end

  def can_promote?
    @color == WHITE ? @position[0].zero? : @position[0] == 7
  end

  def advanced_3_ranks?
    @color == WHITE ? @position[0] == 3 : @position[0] == 4
  end
end
