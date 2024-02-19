# frozen_string_literal: true

require 'json'
require_relative './game'
require_relative './board'

# Methods for prompting the user
def greet_prompt
  puts 'Input the location of the piece you want to move and where you want to move it'
  puts '(Use algebraic notation, use "help" for some extra info!)'
end

def draw_prompt
  puts 'A player can now claim a draw'
end

def comply_prompt
  puts 'Please follow the instructions'
end

def illegal_move_prompt
  puts 'Illegal move!'
end

def check_prompt(player)
  puts "#{player} is in check!"
end

def checkmate_prompt(winner, loser)
  puts "Checkmate for #{loser}! #{winner.capitalize} wins!"
end

def stalemate_prompt(winner, loser)
  puts "Stalemate for #{loser}! #{winner.capitalize} wins!"
end

def draw_alert
  puts 'As per check regulations, a draw has been claimed'
  exit
end

def help_prompt
  puts 'Here some useful commands to know:'
  puts ''
  puts 'draw: if the conditions are met, a player can claim a draw'
  puts 'save: save the current game'
  puts 'quit: exit the programm'
end


AFFIRMATIVE_INPUT = ['yes', 'y'].freeze
NEGATIVE_INPUT = ['no', 'n'].freeze
PROMOTABLE_PIECES = ['Rook', 'Queen', 'Knight', 'Bishop']

# Methods for the user input
def ask_user_load
  while true
    puts 'Found a saved game, do you want to load this match? (y/n)'
    input = get_input
    if AFFIRMATIVE_INPUT.include?(input)
      return true
    elsif NEGATIVE_INPUT.include?(input)
      return false
    end
    comply_prompt
  end
end

def ask_user_input(game)
  while true
    input = get_input
    case input
    when 'Draw'
      draw_alert if game.can_claim_draw?
    when 'Help'
      help_prompt
    when 'Quit'
      exit
    when 'Save'
      save_game(game)
    else
      positions = [to_index(input.split[0]), to_index(input.split[1])]
      return positions unless positions.any?(nil)
    end
    comply_prompt
  end
end

def ask_user_promotion_piece
  puts 'Select which piece the pawn will promote into'
  input = get_input.downcase.capitalize
  return input if PROMOTABLE_PIECES.include?(input)

  comply_prompt
end

def get_input
  gets.chomp.downcase
end

def to_index(string)
  return nil unless valid_input?(string)

  files = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }
  ranks = { "1": 7, "2": 6, "3": 5, "4": 4, "5": 3, "6": 2, "7": 1, "8": 0 }

  [ranks[string[1].to_sym], files[string[0].to_sym]]
end

def valid_input?(input)
  input.size == 2
end
