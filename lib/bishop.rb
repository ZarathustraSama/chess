# frozen_string_literal: true

require_relative './piece'

class Bishop<Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = [*-7..-1, *1..7].map { |elem| [elem, elem] } + [*-7..-1, *1..7].map { |elem| [elem, -elem] }
  end
end
