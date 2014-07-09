require 'io'

describe IO do
  let(:stdin) { double.as_null_object }
  let(:io)    { StandardIO.new(stdin) }

  context 'input' do
    it 'can be asked for the next move' do
      expect(io).to respond_to(:next_move).with(2).arguments
    end

    it 'uses stdin methods to get its input' do
      io.next_move(double, double)

      expect(stdin).to have_received(:gets)
    end
  end

  it 'can print the board' do
    expect(io).to respond_to(:show_contents).with(1).argument
  end
end
