require 'tictactoe/game'
require 'tictactoe/board'
require 'tictactoe/player_factory'
require 'tictactoe-ui/commandline_ui'
require 'tictactoe-ui/commandline_io'

describe TicTacToeUI::CommandlineUI do
  let(:output)  { StringIO.new }
  let(:input)   { StringIO.new }
  let(:display) { TicTacToeUI::CommandlineIO.new(input, output) }
  let(:modes)   { [:a, :b, :c] }
  let(:sizes)   { [:_1x1, :_2x2] }
  let(:ui)      { described_class.new(display) }

  context 'end to end' do
    before :each do
      sizes = TicTacToe::Board.available_sizes
      modes = TicTacToe::PlayerFactory.available_player_pairs
      @ui = described_class.new(display)
      input.string = "1\n1\n"
    end

    it 'sets up a game by asking for board size and game mode' do
      expect(@ui).to receive(:ask_for_board_size).once.and_call_original
      expect(@ui).to receive(:ask_for_game_mode).once.and_call_original

      @ui.setup
    end

    it 'returns a new game from setup' do
      expect(@ui).to receive(:ask_for_board_size).once.and_call_original
      expect(@ui).to receive(:ask_for_game_mode).once.and_call_original

      expect(@ui.setup).to be_a TicTacToe::Game
    end

    it 'sets up and runs the game on #setup_and_play' do
      game = double("Game", :is_playable? => false)
      expect(@ui).to receive(:setup).and_return(game)
      expect(@ui).to receive(:play).with(game)

      @ui.setup_and_play
    end
  end

  context 'setting up a game' do
    before :each do
      input.string = "1\n"
    end

    context '#ask_for_board_size' do
      it 'asks the display to show a list of available board sizes' do
        expect(display).to receive(:show_board_sizes).with(sizes)

        ui = described_class.new(display)
        ui.ask_for_board_size(sizes)
      end

      it 'accepts input after showing the list of available board sizes' do
        expect(display).to receive(:prompt_for_choice).and_call_original

        ui = described_class.new(display)
        ui.ask_for_board_size(modes)
      end

      it 'keeps asking for input until valid choice has been made' do
        input.string = "wrong\ninput\n9\n1"
        expect(display).to receive(:prompt_for_choice).exactly(4).times.and_call_original

        ui = described_class.new(display)
        ui.ask_for_board_size(sizes)
      end
    end

    context '#ask_for_game_mode' do
      it 'asks the display to show a list of available game modes' do
        expect(display).to receive(:show_game_modes).with(modes)

        ui = described_class.new(display)
        ui.ask_for_game_mode(modes)
      end

      it 'accepts input after showing the list of available game modes' do
        expect(display).to receive(:prompt_for_choice).and_call_original

        ui = described_class.new(display)
        ui.ask_for_game_mode(modes)
      end

      it 'keeps asking for input until valid choice has been made' do
        input.string = "wrong\ninput\n9\n1"
        expect(display).to receive(:prompt_for_choice).exactly(4).times.and_call_original

        ui = described_class.new(display)
        ui.ask_for_game_mode(modes)
      end
    end
  end

  context 'playing a game' do
    let(:game) { double("Game", :is_ongoing? => false, :play_next_round => nil) }

    it 'plays a game until its done' do
      allow(game).to receive(:is_playable?).and_return(true, false)
      ui.play(game)

      expect(game).to have_received(:is_playable?).exactly(2).times
    end

    it 'plays rounds consecutively' do
      allow(game).to receive(:is_playable?).and_return(true, true, false)
      ui.play(game)

      expect(game).to have_received(:play_next_round).exactly(2).times
    end
  end
end
