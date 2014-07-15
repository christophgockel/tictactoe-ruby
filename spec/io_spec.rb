require 'spec_helper'

require 'io'

shared_context 'an IO object' do
  it 'responds to all IO related messages' do
    expect(subject).to respond_to(:next_location).with(2).arguments
    expect(subject).to respond_to(:display_board).with(1).argument
  end
end

describe CommandLineIO do
  it_should_behave_like 'an IO object'

  let(:input) { StringIO.new('1') }
  let(:output) { StringIO.new }
  subject { CommandLineIO.new(input, output) }

  context 'input' do
    context 'valid' do
      it 'converts given value to number - 1' do
        input.string = '3'
        move = subject.next_location(double, double)

        expect(move).to eq 2
      end
    end

    context 'invalid' do
      it 'raises exception' do
        input.string = 'no number'
        expect { subject.next_location(double, double) }.to raise_error(InvalidInput)
      end

      it 'given location must be >0' do
        input.string = '0'
        expect { subject.next_location(double, double) }.to raise_error(InvalidInput)
      end

      it 'given location must be <=9' do
        input.string = '10'
        expect { subject.next_location(double, double) }.to raise_error(InvalidInput)
      end
    end
  end

  context 'output' do
    it 'displays board contents' do
      subject.display_board(board_with('abcdefghi'))
      expect(output.string).to include('a | b | c')
      expect(output.string).to include('d | e | f')
      expect(output.string).to include('g | h | i')
    end

    it 'empty board has 1 based indexes' do
      subject.display_board(board_with('         '))
      expect(output.string).to include('1 | 2 | 3')
      expect(output.string).to include('4 | 5 | 6')
      expect(output.string).to include('7 | 8 | 9')
    end

    it 'asks the player for the next move' do
      subject.next_location('A', double)
      expect(output.string). to include 'Next move for A:'
    end

    it 'informs about an invalid move' do
      subject.display_invalid_move_message
      expect(output.string). to include 'Invalid move.'
    end
  end
end

describe AutomaticInput do
  it_should_behave_like 'an IO object'

  it 'places middle cell when player chose corder' do
    ai = AutomaticInput.new
    expect(ai.next_location('o', board_with('x        '))).to eq 5
  end
end
