require 'spec_helper'

require 'game'
require 'board'
require 'fake_player'

describe Game do
  let(:player_a) { FakePlayer.new('a', 1) }
  let(:player_b) { FakePlayer.new('b', 2) }
  let(:board)    { board_with('         ') }
  let(:game)     { Game.new(player_a, player_b, board) }

  context 'rules' do
    it 'switches players for each round' do
      allow(player_a).to receive(:next_move).and_call_original
      allow(player_b).to receive(:next_move).and_call_original

      game = game_with_board('         ')

      game.play_next_round
      game.play_next_round

      expect(player_a).to have_received(:next_move)
      expect(player_b).to have_received(:next_move)
    end

    it 'can only be played until its over' do
      game = game_with_board('aabababba')

      expect { game.play_next_round }.to raise_error(Game::Over)
    end
  end

  context 'end results' do
    it 'can return the winner of a game' do
      game = game_with_board('aaa      ')

      expect(game.is_ongoing?).to eq false
      expect(game.winner).to eq 'a'
    end

    it 'returns empty string when there is no winner' do
      game = game_with_board('ababcbaba')

      expect(game.is_ongoing?).to eq false
      expect(game.winner).to eq ''
    end
  end

  context 'player interaction' do
    it 'in each round a player will be asked for its next move' do
      player_a = FakePlayer.new('a', 5)
      expect(player_a).to receive(:next_move).and_call_original

      game = Game.new(player_a, player_b, board_with('baba bbaa'))
      game.play_next_round
    end

    it 'passes the board when asking a player for a move' do
      expect(player_a).to receive(:next_move).with(board).and_call_original

      game.play_next_round
    end

    it 'places player moves on board' do
      expect(board).to receive(:set_move).with(1, player_a.mark)

      game.play_next_round
    end

    it 'can be asked whether the round could be played' do
      player_a = FakePlayer.new('a', 1)
      expect(player_a).to receive(:next_move).and_call_original
      game = Game.new(player_a, player_b, board_with('baba bbaa'))
      game.play_next_round

      expect(game.round_could_be_played).to eq false
    end

    it 'can be asked whether the round could be played - 2' do
      player_a = FakePlayer.new('a', 5)
      expect(player_a).to receive(:next_move).and_call_original
      game = Game.new(player_a, player_b, board_with('baba bbaa'))
      game.play_next_round

      expect(game.round_could_be_played).to eq true
    end
  end

  def game_with_board(board_state)
    Game.new(player_a, player_b, board_with(board_state))
  end
end
