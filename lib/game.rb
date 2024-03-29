# frozen_string_literal: true

require_relative './board'

# This is where interaction of the pieces and changes to the board takes place
class Game
  attr_accessor :board, :player, :moves_to_draw, :double_step_pawn

  def initialize(board = Board.new, player = WHITE, moves_to_draw = 0, double_step_pawn = nil)
    @board = board
    @player = player
    @moves_to_draw = moves_to_draw
    @double_step_pawn = double_step_pawn
  end

  # Called at the beginning of a new game, populates the board and initialized the moves of the moving player
  def initial_state
    @board.populate_board
    @board.update_moves(@player)
  end

  # When a legal move is performed, updates the state of the game
  def update_state(piece, move)
    update_counter(piece, move)
    update_pawn(board.move_piece(piece, move), move)
    set_player
    @board.update_moves(@player)
  end

  # If the moved piece is a pawn, checks if a double step was done and if it can be promoted
  def update_pawn(pawn, move)
    return unless pawn.instance_of?(::Pawn)

    @double_step_pawn = pawn.double_step?(move[0]) ? pawn.position : nil
    @board.double_step_pawn = @double_step_pawn
    promote(pawn)
  end

  # If no pawn has been moved or no capture performed, adds one to the counter
  def update_counter(piece, move)
    unless piece.instance_of?(::Pawn) && @board.empty?(move)
      @moves_to_draw += 1
    else
      @moves_to_draw = 0
    end
  end

  # The move has to be in the set of moves of the piece, and it should not cause a self-check
  # Capturing the king is also not allowed
  def legal_move?(piece, move, player)
    return if piece.nil?

    square = @board.board[move[0]][move[1]]
    piece.legal_move?(move, player) && !square.instance_of?(::King) && !next_check?(piece, move, player)
  end

  # The condition for a player to claim a draw
  def can_claim_draw?
    @moves_to_draw >= 50
  end

  # If a pawn can be promoted places the new piece in the same square, overwriting the pawn
  def promote(pawn)
    return unless pawn.can_promote?

    piece = ask_user_promotion_piece
    @board.board[pawn.position[0]][pawn.position[1]] = Object.const_get(piece).new(pawn.position, pawn.color, false, [])
  end

  # The method for drawing the board
  def draw_board(board = @board.board)
    puts ''
    i = 9
    board.each { |row| draw_row(row, i -= 1) }
    puts '   a b c d e f g h'
    puts ''
  end

  private

  # Changes the player that has to move
  def set_player
    @player = @player == WHITE ? BLACK : WHITE
  end

  # Simulates a new board and verifies if a check occurs
  def next_check?(piece, move, player)
    @board.simulate_new_board(piece, move).check?(player)
  end

  def draw_row(row, i)
    print "#{i} "
    row.each do |square|
      if square.nil?
        print '|_'
      else
        print "|#{square.symbol}"
      end
    end
    print '|'
    puts ''
  end
end
