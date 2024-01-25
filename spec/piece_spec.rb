# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  subject(:piece) { described_class.new([0, 0], 'Black', '\u265C') }

  describe '#move' do
    let(:move) { [3, 0] }

    it 'returns the new position of the piece' do
      expect(piece.move(move)).to eql([3, 0])
    end
  end

  describe '#simulate_all_moves' do
    let(:moves) { [[1, 0], [2, 0], [3, 0]] }

    it 'returns an array of all simulated positions' do
      expect(piece.simulate_all_moves(moves)).to eql([[1, 0], [2, 0], [3, 0]])
    end
  end
end
