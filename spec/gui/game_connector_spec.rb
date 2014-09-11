require 'gui/game_connector'

describe GameConnector do
  let(:connector) { GameConnector.new }

  [:human_vs_human,
   :human_vs_computer,
   :computer_vs_human,
   :computer_vs_computer
  ].each do |game_type|
    it "creates new #{game_type} game" do
      game = connector.create_game(game_type)

      expect(game).to respond_to(:play_next_round)
      expect(game).to respond_to(:is_ongoing?)
    end
  end

  it 'holds the window title' do
    expect(connector.window_title).not_to be_nil
  end

  it 'holds a status text' do
    expect(connector.status_text).not_to be_nil
  end

  it 'acts as an observable' do
    observer = double("Observer", :update => nil)

    connector.add_observer(observer)
    connector.inform_observers

    expect(observer).to have_received(:update)
  end

  context 'status' do
    before :each do
      connector.create_game(:human_vs_human)
    end

    context 'end of game' do
      it 'knows when x is the winner' do
        allow(connector.game).to receive(:winner).and_return('x')
        connector.update_status
        expect(connector.status_text).to eq 'Winner is: x.'
      end

      it 'knows when o is the winner' do
        allow(connector.game).to receive(:winner).and_return('o')
        connector.update_status
        expect(connector.status_text).to eq 'Winner is: o.'
      end

      it 'knows when game ended in draw' do
        allow(connector.game).to receive(:is_ongoing?).and_return(false)
        connector.update_status
        expect(connector.status_text).to eq 'Game ended in draw.'
      end
    end

    context 'ongoing game' do
      it 'knows which player has to move next' do
        connector.update_status
        expect(connector.status_text).to eq 'Next move for: x'
      end
    end
  end

  context 'game types' do
    attr_reader :process

    context 'human vs. human' do
      before :each do
        connector.create_game(:human_vs_human)
        @process = connector.game_process
      end

      it 'plays the move' do
        expect(process.game).to receive(:play_next_round)
        process.play(3)
      end

      it 'updates the status on #play' do
        expect(connector).to receive(:update_status)
        process.play(3)
      end
    end

    context 'human vs. computer' do
      before :each do
        connector.create_game(:human_vs_computer)
        @process = connector.game_process
      end

      it 'plays a round for the human player, and one for the computer player' do
        expect(process.game).to receive(:play_next_round).exactly(:twice)
        process.play(3)
      end

      it 'updates the status on #play' do
        expect(connector).to receive(:update_status)
        process.play(3)
      end

      it 'updates the status when game is over' do
        allow(process.game).to receive(:play_next_round).and_raise(Game::Over)
        expect(connector).to receive(:update_status)
        process.play(3)
      end
    end

    context 'computer vs. human' do
      before :each do
        stub_const("Thread", FakeThread)

        connector.create_game(:computer_vs_human)
        @process = connector.game_process
      end

      it 'starts with directly playing a round' do
        expect(process.game).to receive(:play_next_round)
        process.start
      end

      it 'kills the Thread when stopping' do
        expect(FakeThread).to receive(:kill)
        process.start

        process.stop
      end

      it 'plays a round for the human player, and one for the computer player' do
        expect(process.game).to receive(:play_next_round).exactly(:twice)
        process.play(3)
      end
    end

    context 'computer vs. computer' do
      before :each do
        stub_const("Thread", FakeThread)

        connector.create_game(:computer_vs_computer)
        @process = connector.game_process

        allow_any_instance_of(DelayedComputerPlayer).to receive(:sleep).and_return(nil)
      end

      it 'spawns new thread' do
        expect(FakeThread).to receive(:new)
        process.start
      end

      it 'plays the whole game when started' do
        process.start
        expect(connector.status_text).to include 'draw'
      end

      it 'kills the Thread when stopping' do
        expect(FakeThread).to receive(:kill)
        process.start

        process.stop
      end
    end

    class FakeThread
      def initialize
        yield
      end

      def self.kill
      end
    end
  end
end
