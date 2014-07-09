require 'rspec'

require 'game'
require 'player'
require 'board'


describe Game do
  let(:player_x) { Player.X }
  let(:player_o) { Player.O }
  let(:board)    { Board.new }
  let(:display)  { double }

  before(:each) do
    allow(player_x).to receive(:next_move).and_return(Player::Move.new(Player::X, 1))
    allow(player_o).to receive(:next_move).and_return(Player::Move.new(Player::O, 2))
    allow(board).to receive(:is_completed?).and_return(false, false, true)
    allow(display).to receive(:show_contents)

    @game = Game.new([player_x, player_o], board, display)
  end

  it 'can not be started without enough players' do
    game = Game.with_players([])
    expect { game.start }.to raise_error(Game::InsufficientAmountOfPlayers)
  end

  it 'needs two players to be started' do
    allow(board).to receive(:has_winner?).and_return(true, false, false, true)
    game = Game.new([double.as_null_object, double.as_null_object], board, display)
    expect { game.start }.not_to raise_error
  end

  it 'passes the board when asking a player for a move' do
    @game.start
    expect(player_x).to have_received(:next_move).with(board).at_least(:once)
  end

  it 'places player moves on board' do
    board = double
    game = Game.new([player_x, player_o], board)

    expect(board).to receive(:set_move).with(Player::X, 1)
    game.place_move_of(player_x)
  end

  it 'runs until done' do
    allow(board).to receive(:is_completed?).and_return(false, false, true)
    expect(board).to receive(:is_completed?).exactly(3).times

    @game.start
  end

  it 'is asking players consecutively for moves' do
    allow(board).to receive(:is_completed?).and_return(false, true)

    expect(player_x).to receive(:next_move).exactly(1).times
    expect(player_o).to receive(:next_move).exactly(1).times

    @game.start
  end

  it 'pushes the board to a display for each round plus at the end of a game' do
    expect(display).to receive(:show_contents).with(board).exactly(4).times

    @game.start
  end

  it 'returns the winner when done' do
    allow(board).to receive(:winner?).and_return(Player::O)
    expect(@game.start).to eq(Player::O)
  end
end
