require 'rspec'

require 'game'
require 'player'
require 'board'


describe Game do
  let(:player_x) { Player.X }
  let(:player_o) { Player.O }
  let(:board)    { Board.new }
  let(:rules)    { Rules.new }

  before(:each) do
    allow(player_x).to receive(:next_move).and_return(Move.new(Player::X, 1))
    allow(player_o).to receive(:next_move).and_return(Move.new(Player::O, 2))
    allow(rules).to receive(:has_winner?).and_return(false, true)

    @game = Game.new([player_x, player_o], board, rules)
  end

  it 'can not be started without enough players' do
    game = Game.with_players([])
    expect { game.start }.to raise_error(Game::InsufficientAmountOfPlayers)
  end

  it 'needs two players to be started' do
    game = Game.new([double.as_null_object, double.as_null_object], board, rules)
    expect { game.start }.not_to raise_error
  end

  it 'asks the players for moves' do
    @game.start
    expect(player_x).to have_received(:next_move)
  end

  it 'places player moves on board' do
    board = double
    game = Game.new([player_x, player_o], board)

    expect(board).to receive(:set).with(kind_of(Move))
    game.place_move_of(player_x)
  end

  it 'runs until done' do
    allow(rules).to receive(:has_winner?).and_return(false, false, true)
    expect(rules).to receive(:has_winner?).exactly(3).times

    @game.start
  end

  it 'is asking players consecutively for moves' do
    allow(rules).to receive(:has_winner?).and_return(false, false, true)

    expect(player_x).to receive(:next_move).exactly(1).times
    expect(player_o).to receive(:next_move).exactly(1).times

    @game.start
  end
end
