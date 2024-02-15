# frozen_string_literal: true

require 'json'
require_relative './game'
require_relative './board'

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

def save_game(game)
  Dir.mkdir('saves') unless Dir.exist?('saves')

  File.open('saves/game.json', 'w') do |file|
    file.puts game_to_json(game)
  end
end

def saved_game?
  begin
    !Dir.empty?('saves')
  rescue Errno::ENOENT
    false
  end
end

def load_game
  File.open('saves/game.json', 'r') do |file|
    game_from_json(file.gets)
  end
end
