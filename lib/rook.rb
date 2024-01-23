# frozen_string_literal: true

require_relative './piece'

# The rook piece
class Rook < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end
end
