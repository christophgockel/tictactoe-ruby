require 'board_helper'
require 'fake_player'

describe BoardHelper do
#  let(:helper) {
#    Class.new do
#      include BoardHelper
#    end
#  }

  let(:helper) { Object.new }
  
  before(:each) do
    helper.extend(BoardHelper)
  end

  describe 'marks' do
    it 'has default marks' do
      expect(helper.mark_a).to eq 'a'
      expect(helper.mark_b).to eq 'b'
    end
  end

  describe '#board_with' do
    it 'returns board with a given state' do
      board = helper.board_with('123456789')

      expect(board.rows).to eq [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']]
    end

    it 'places empty cells for empty spots in the string' do
      board = helper.board_with('a cd fg i')

      expect(board.rows).to eq [['a', nil, 'c'], ['d', nil, 'f'], ['g', nil, 'i']]
    end
  end

  describe '#board_content' do
    it 'stringifies a given board' do
      board = helper.board_with('oox      ')

      expect(helper.board_content(board)).to eq 'oox      '
    end
  end

  describe BoardHelper::Builder do
    describe '#in' do
      it 'can build new boards with pre-set player moves' do
        player = FakePlayer.new('x', 3)
        builder = BoardHelper::Builder.new(player)

        expect(builder.in('         ')).to eq '  x      '
      end
    end
  end
end
