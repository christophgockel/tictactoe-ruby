require 'spec_helper'

require 'game'
require 'board'
require 'fake_player'

describe Game do
  let(:player_one) { FakePlayer.new('a', 1) }
  let(:player_two) { FakePlayer.new('b', 2) }
  let(:board)    { board_with('         ') }
  let(:game)     { Game.new(player_one, player_two, board) }

  context 'rules' do
    it 'switches players for each round' do
      game = game_with_board('         ')

      game.play_next_round
      game.play_next_round

      expect(player_one.next_move_has_been_called).to be_truthy
      expect(player_two.next_move_has_been_called).to be_truthy
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
      player_one = FakePlayer.new('a', 5)

      game = Game.new(player_one, player_two, board_with('baba bbaa'))
      game.play_next_round

      expect(player_one.next_move_has_been_called).to be_truthy
    end

    it 'passes the board when asking a player for a move' do
      game.play_next_round

      expect(player_one.passed_board).to eq board
    end

    it 'places player moves on board' do
      expect(board).to receive(:set_move).with(1, player_one.mark)

      game.play_next_round
    end

    it 'can be asked whether the round could be played' do
      player_one = FakePlayer.new('a', 1)
      game = Game.new(player_one, player_two, board_with('baba bbaa'))
      game.play_next_round

      expect(game.round_could_be_played).to eq false
    end

    it 'can be asked whether the round could be played - 2' do
      player_one = FakePlayer.new('a', 5)
      game = Game.new(player_one, player_two, board_with('baba bbaa'))
      game.play_next_round

      expect(game.round_could_be_played).to eq true
    end
  end

  def game_with_board(board_state)
    Game.new(player_one, player_two, board_with(board_state))
  end
end
