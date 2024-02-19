# frozen_string_literal: true

require 'json'
require_relative './game'
require_relative './board'

# Methods for saving/loading the game
def save_game(game)
  Dir.mkdir('saves') unless Dir.exist?('saves')

  File.open('saves/game.json', 'w') do |file|
    file.puts game_to_json(game)
  end
end

def load_game
  File.open('saves/game.json', 'r') do |file|
    game_from_json(file.gets)
  end
end

# check for saved game and ask user if they want to use it
def try_loading_game
  load_game if saved_game? && ask_user_load
end

def saved_game?
  begin
    !Dir.empty?('saves')
  rescue Errno::ENOENT
    false
  end
end

def game_to_json(game)
  JSON.dump ({
    :board => board_to_json(game.board.board),
    :player => game.player,
    :moves_to_draw => game.moves_to_draw
  })
end

def board_to_json(board)
  board.flatten.compact.map do |piece|
    JSON.dump ({
      :piece => piece.class.name,
      :position => piece.position,
      :color => piece.color,
      :moved => piece.moved,
      :moves => piece.moves
    })
  end
end

def game_from_json(game_string)
  data = JSON.load game_string
  Game.new(load_board(data['board']), data['player'], data['moves_to_draw'])
end

def load_board(saved_board)
  board = Board.new
  saved_board.each do |piece|
    p = JSON.parse(piece)
    board.add(p['piece'], p['position'], p['color'], p['moved'], p['moves'])
  end
  board
end

# Methods for prompting the user
def greet_prompt
  puts 'Input the location of the piece you want to move and where you want to move it'
  puts '(Use algebraic notation)'
end

def draw_prompt
  puts 'A player can now claim a draw, since the requirements have been met'
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
end

def save_prompt
  puts 'Game has been saved'
end

def promotion_prompt
  puts 'Select which piece the pawn will promote into'
end


AFFIRMATIVE_INPUT = ['yes', 'y'].freeze
NEGATIVE_INPUT = ['no', 'n'].freeze
DRAW = 'draw'.freeze
SAVE = 'save'.freeze
QUIT = 'quit'.freeze
FILES = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze
RANKS = { "1": 7, "2": 6, "3": 5, "4": 4, "5": 3, "6": 2, "7": 1, "8": 0 }.freeze
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

def ask_user_move
  while true
    input = get_input
    case input
    when SAVE
      return SAVE
    when DRAW
      return DRAW
    when QUIT
      return QUIT
    else
      positions = [to_index(input.split[0]), to_index(input.split[1])]
      return positions unless positions.any?(nil)
    end
    comply_prompt
  end
end

def ask_user_promotion_piece
  promotion_prompt
  input = get_input.downcase.capitalize
  return input if PROMOTABLE_PIECES.include?(input)

  comply_prompt
end

def get_input
  gets.chomp.downcase
end

def to_index(string)
  return nil unless valid_input?(string)

  [RANKS[string[1].to_sym], FILES[string[0].to_sym]]
end

def valid_input?(input)
  input.size == 2
end
