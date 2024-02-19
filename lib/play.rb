# frozen_string_literal: true

require_relative './game'
require_relative './utility'

def play
  game = try_loading_game

  if game.nil?
    game = Game.new
    game.initial_state
  end

  board = game.board # The board object
  checkboard = board.board # The 2D array reppresentation of the board
  player = game.player
  greet_prompt
  game.draw_board(checkboard)

  while true
    game.update_state
    return if game_over?(board, player)

    check_prompt if board.check?(player)
    puts "#{player} moves"
    input = ask_user_move

    case input
    when QUIT
      exit
    when DRAW
      return draw_alert if game.can_claim_draw?
    when SAVE

    end

    piece = board.find_piece(input[0])
    unless piece.nil?
      move = input[1]

      if game.legal_move?(piece, move, player)
        board.move_piece(piece, move)
        promote(piece, ask_user_promotion_piece) if piece.instance_of?(::Pawn) && piece.can_promote?
        game.update_state
        game.draw_board(checkboard)
        player = game.player
      else
        comply_prompt
      end
    end
  end
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
