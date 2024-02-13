# frozen_string_literal: true

require_relative './board'

FILES = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze
RANKS = { "1": 7, "2": 6, "3": 5, "4": 4, "5": 3, "6": 2, "7": 1, "8": 0 }.freeze

# This is where interaction of the pieces and changes to the board takes place
class Game
  attr_accessor :board, :player

  def initialize(board = Board.new)
    @board = board
    @player = nil
  end

  def initial_state
    @board.populate_board
    set_player
  end

  def set_player
    return WHITE if @player.nil?

    @player = @player == WHITE ? BLACK : WHITE
  end

  def legal_input?(input)
    move = input.downcase.slice(' ')
    from = to_index(move[0])
    towards = to_index(move[1])
    @board.board[from[0]][from[1]]&.moves&.include?(towards)
  end

  def promote(pawn, piece)
    @board.board[pawn.position[0]][pawn.position[1]] = Object.const_get(piece).new(pawn.position, pawn.color)
  end

  def game_cycle
    # start board
    # start loop
    #   ask user input
    #   if wrong format, repeat
    #   check piece, check moves
    #   if move is not one of the technically possible moves, repeat
    #   if fake board causes a check for the player, repeat
    #   modify board
    #   check for checks, mates, stalemate for the other player
    #   check for promotion if piece is a pawn
    #   close game if game over
    #   change player
    # end loop
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
        print '| '
      else
        print "|#{square.symbol}"
      end
    end
    print '|'
    puts ''
  end

  # Utility method
  def to_index(string)
    s = string.slice('')
    [RANKS[s[0].to_sym], FILES[s[1].to_sym]]
  end
end
