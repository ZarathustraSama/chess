# frozen_literal_string: true

require_relative './piece'

# The queen piece
class Queen < Piece
  attr_accessor :moves

  def initialize(*args)
    super
    @moves = []
  end
end
