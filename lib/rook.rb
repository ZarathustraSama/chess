# frozen_string_literal: true

require_relative './piece'

class Rook<Piece
  attr_accessor :moves

  def initialize
    super
    @moves = [*-7..-1, *1..7].map { |element| [element, 0] } + [*-7..-1, *1..7].map { |element| [0, element] }
  end
end
