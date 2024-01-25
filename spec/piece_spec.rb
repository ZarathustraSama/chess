# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  describe '#move' do
    subject(:piece) { described_class.new([0, 0], 'Black', '\u265C') }
    let(:move) { [3, 0] }

    it 'returns the new position of the piece' do
      expect(piece.move(move)).to eql([3, 0])
    end
  end
end
