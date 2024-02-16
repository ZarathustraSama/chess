# frozen_string_literal: true

require_relative './board'



# This is where interaction of the pieces and changes to the board takes place
class Game
  attr_accessor :board, :player

  def initialize(board = Board.new, player = nil, moves_to_draw = 0)
    @board = board
    @player = player
    @moves_to_draw = moves_to_draw
  end

  def initial_state
    @board.populate_board
    set_player
    @board.update_moves(@player)
  end

  def set_player
    case @player
    when WHITE
      @player = BLACK
    when BLACK
      @player = WHITE
    else
      @player = WHITE
    end
  end

  # The input is an array with the position of the piece and the move to make
  # The move has to be in the set of moves of the piece, and it should not cause a self-check
  def legal_input?(input)
    piece = @board.find_piece(input[0])
    piece&.moves.include?(input[1]) && !check?(simulate_new_board(piece, input[1]))
  end

  def promote(pawn, piece)
    @board.board[pawn.position[0]][pawn.position[1]] = Object.const_get(piece).new(pawn.position, pawn.color)
  end


  def draw_board(board = @board.board)
    puts ''
    board.each { |row| draw_row(row) }
    puts ''
  end

  private

  def draw_row(row)
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

  # Utility method

end
