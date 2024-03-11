# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'

describe King do
  describe '#castling?' do
    let(:board) { instance_double(Board) }
    subject(:king) { described_class.new([0, 4], BLACK, PIECES[:b_king]) }
    let(:rook) { Rook.new([0, 0], BLACK, PIECES[:b_rook]) }
    let(:squares) { [[0, 1], [0, 2], [0, 3]] }

    context 'If there are pieces between the king and the rook' do

      before do
        allow(board).to receive(:add).with('Rook', [0, 0], BLACK, PIECES[:b_rook])
        allow(board).to receive(:add).with('King', [0, 4], BLACK, PIECES[:b_king])
        allow(board).to receive(:add).with('Rook', [0, 1], BLACK, PIECES[:b_rook])
        allow(board).to receive(:check?).with(BLACK).and_return(false)
      end

      it 'returns false' do
        expect(king.castling?(board, rook, squares)).to be(false)
      end
    end

    context 'If there is a piece that threatens check' do

      before do
        allow(board).to receive(:add).with('Rook', [0, 0], BLACK, PIECES[:b_rook])
        allow(board).to receive(:add).with('King', [0, 4], BLACK, PIECES[:b_king])
        allow(board).to receive(:add).with('Rook', [1, 1], WHITE, PIECES[:w_rook])
        allow(board).to receive(:check?).with(BLACK).and_return(true)
      end

      it 'returns false' do
        expect(king.castling?(board, rook, squares)).to be(false)
      end
    end

    context 'If nothing stands between the king and the rook' do

      before do
        allow(board).to receive(:add).with('Rook', [0, 0], BLACK, PIECES[:b_rook])
        allow(board).to receive(:add).with('King', [0, 4], BLACK, PIECES[:b_king])
      end

      it 'returns true' do
        expect(king.castling?(board, rook, squares)).to be(true)
      end
    end
  end
end
