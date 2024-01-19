# frozen_string_literal: true

require_relative './piece'

class Knight<Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
  end
end
