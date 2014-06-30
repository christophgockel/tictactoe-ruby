require 'rspec'

require 'player'


describe Player do
  it "has a symbol" do
    player = Player.new("X")
    expect(player.symbol).to eq "X"
  end

  it "asks an input object to get its next move" do
    input = double("Input", :next_move => 42)
    player = Player.new("X", input)
    player.next_move

    expect(input).to have_received(:next_move)
  end
end
