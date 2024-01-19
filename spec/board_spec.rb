# frozen_string_literal: true

describe Board do
  describe '#find_king' do
    subject(:board) { described_class.new }

    it 'returns the position of the specified king' do
      expect(board.find_king('White')).to eql([7, 4])
    end
  end
end
