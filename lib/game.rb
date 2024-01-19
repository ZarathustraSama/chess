# frozen_string_literal: true

class Game
  attr_accessor :player_1, :player_2

  def initialize
    @player = nil
  end

  def set_player(color)
    return 'White' if @player.nil?

    @player.white? ? 'Black' : 'White'
  end

  private

  def white?
    @player == 'White'
  end
end
