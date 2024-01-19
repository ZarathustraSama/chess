# frozen_string_literal: true

require_relative './board'

class Game
  def initialize
    @board = Board.new
  end

  def check?

  end

  def game_over?
    mate? || stalemate?
  end

  def mate?

  end

  def stalemate?

  end
end
