# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/bishop'
require_relative '../lib/king'
require_relative '../lib/knight'
require_relative '../lib/pawn'
require_relative '../lib/piece'
require_relative '../lib/queen'
require_relative '../lib/rook'

describe Board do
  describe '#add' do
    subject(:board) { described_class.new }

    before do
      allow(board).to receive(:add).with('King', [0, 4], 'Black', PIECES[:b_king])
    end

    # if you want to test unprivate method
    xit 'adds the correct piece in the correct place' do
      expect(board.board[0][4]).to be_instance_of(King)
    end
  end
end
