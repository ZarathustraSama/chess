# frozen_string_literal: true

require_relative './piece'

# The bishop piece
class Bishop < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end
end
