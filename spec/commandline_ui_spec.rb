require 'spec_helper'

require 'commandline_ui'
require 'commandline_io'

describe CommandlineUI do
  let(:output)  { StringIO.new }
  let(:input)   { StringIO.new }
  let(:display) { CommandlineIO.new(input, output) }
  let(:ui)      { CommandlineUI.new(display) }
  let(:modes)   { [:a, :b, :c] }

  context 'setting up a game' do
    before :each do
      input.string = "1\n"
    end

    it 'asks the display to show a list of available game modes' do
      expect(display).to receive(:show_game_modes).with(modes)

      ui = CommandlineUI.new(display)
      ui.ask_for_game_mode(modes)
    end

    it 'accepts input after showing the list of available game modes' do
      expect(display).to receive(:prompt_for_choice).and_call_original

      ui = CommandlineUI.new(display)
      ui.ask_for_game_mode(modes)
    end

    it 'keeps asking for input until valid choice has been made' do
      input.string = "wrong\ninput\n9\n1"
      expect(display).to receive(:prompt_for_choice).exactly(4).times.and_call_original

      ui = CommandlineUI.new(display)
      ui.ask_for_game_mode(modes)
    end
  end

  context 'playing a game' do
    let(:game) { double("Game", :is_ongoing? => false, :play_next_round => nil) }

    it 'plays a game until its done' do
      allow(game).to receive(:is_ongoing?).and_return(true, false)
      ui.play(game)

      expect(game).to have_received(:is_ongoing?).exactly(2).times
    end

    it 'plays rounds consecutively' do
      allow(game).to receive(:is_ongoing?).and_return(true, true, false)
      ui.play(game)

      expect(game).to have_received(:play_next_round).exactly(2).times
    end
  end
end
