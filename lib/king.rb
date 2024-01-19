# frozen_string_literal: true

require_relative './piece'

class King<Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = [-1, 1].map { |elem| [0, elem] } + [-1, 1].map { |elem| [elem, 0] } +
              [-1, 1].map { |elem| [elem, elem] } + [-1, 1].map { |elem| [elem, -elem] }
  end
end
