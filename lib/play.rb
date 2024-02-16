# frozen_string_literal: true

require_relative './game'
require_relative './utility'

def play
  game = try_loading_game

  if game.nil?
    game = Game.new
    game.initial_state
  end

  board_o = game.board # The board object
  board_a = board_o.board # The 2D array reppresentation of the board

  while true
    draw_board(board_a)
    player = game.player
    input = ask_user_move(player)
    if legal_input?(input)
      board_o.move_piece
    end
  end
end

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
