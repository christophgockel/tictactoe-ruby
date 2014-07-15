require 'spec_helper'

require 'game'
require 'player'
require 'board'

describe Game do
  let(:player_a) { object_double(Player.new('a')).as_null_object }
  let(:player_b) { object_double(Player.new('b')).as_null_object }
  let(:board)    { instance_double(Board).as_null_object }
  let(:display)  { double.as_null_object }

  before(:each) do
    allow(player_a).to receive(:next_move).and_return(Player::Move.new(player_a.mark, 1))
    allow(player_b).to receive(:next_move).and_return(Player::Move.new(player_b.mark, 2))

    @game = Game.new([player_a, player_b], board, display)
  end

  context 'basic rules' do
    it 'runs until done' do
      prepare_two_round_game
      @game.start
      expect(board).to have_received(:is_completed?).exactly(3).times
    end

    it 'returns the winner when done' do
      prepare_player_b_as_winner
      expect(@game.start).to eq(player_b.mark)
    end

    def prepare_two_round_game
      allow(board).to receive(:is_completed?).and_return(false, false, true)
    end

    def prepare_player_b_as_winner
      allow(board).to receive(:winner?).and_return(true)
    end
  end

  context 'when not enough players' do
    let(:game) { Game.new([], board, display) }

    it 'can not be started' do
      expect { game.start }.to raise_error(Game::InsufficientAmountOfPlayers)
    end
  end

  context 'player interaction' do
    it 'passes the board when asking a player for a move' do
      @game.start
      expect(player_a).to have_received(:next_move).with(board).at_least(:once)
    end

    it 'places player moves on board' do
      expect(board).to receive(:set_move).with(1, player_a.mark)
      @game.place_move_of(player_a)
    end

    it 'is asking each player for moves' do
      prepare_two_round_game
      @game.start

      expect(player_a).to have_received(:next_move).exactly(1).times
      expect(player_b).to have_received(:next_move).exactly(1).times
    end

    xit 'displays a message on invalid moves' do

    end

    def prepare_two_round_game
      allow(board).to receive(:is_completed?).and_return(false, true)
    end
  end

  context 'display' do
    it 'will be updated for each game round plus at the end of a game' do
      prepare_two_round_game
      @game.start
      expect(display).to have_received(:display_board).exactly(4).times.with(board)
    end

    def prepare_two_round_game
      allow(board).to receive(:is_completed?).and_return(false, false, true)
    end
  end

  context 'end results' do
    xit 'returns the symbol of the winner' do
      game = dummy_game_with('aaa      ')

      expect(game.start).to eq 'a'
    end

    def dummy_game_with(board_content)
      board = board_with('aaa      ')
      allow(player_a).to receive(:next_move).and_return(Player::Move.new(player_a.mark, 2))

      Game.new([player_a, player_b], board, display)
    end
  end
end
