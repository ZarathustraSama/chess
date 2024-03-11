# frozen_string_literal: true

require_relative './game'
require_relative './utility'
require_relative './save_load'

def play
  clean_terminal
  game = load_game
  if game.nil?
    game = Game.new
    game.initial_state
  end
  board = game.board
  game.draw_board
  greet_prompt
  while true
    player = game.player
    exit if game_over?(board, player)

    check_prompt(player) if board.check?(player)
    puts "#{player} moves"
    input = ask_user_input(game)
    piece, move = board.find_piece(input[0]), input[1]
    if game.legal_move?(piece, move, player)
      game.update_state(piece, move)
      clean_terminal
      game.draw_board
    else
      illegal_move_prompt
    end
  end
end

def clean_terminal
  system "clear" || "cls"
end

def game_over?(board, player)
  opponent = player == WHITE ? BLACK : WHITE
  if board.game_over?(player)
    if board.mate?(player)
      checkmate_prompt(opponent, player)
      true
    elsif board.stalemate?(player)
      stalemate_prompt(opponent, player)
      true
    end
  end
end
