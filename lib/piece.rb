# frozen_string_literal: true

# Every component of the board will inherit this class
class Piece
  def initialize(position)
    @position = position
  end

  def move(position)
    @position = position
  end
end
