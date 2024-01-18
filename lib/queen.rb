# frozen_literal_string: true

require_relative './piece'

class Quenn<Piece
  attr_accessor :moves

  def initialize
    super
    @moves = [*-7..-1, *1..7].map { |elem| [elem, elem] } + [*-7..-1, *1..7].map { |elem| [elem, -elem] } +
              [*-7..-1, *1..7].map { |element| [element, 0] } + [*-7..-1, *1..7].map { |element| [0, element] }
  end
end
