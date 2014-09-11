require 'gui/game_widget'
require 'gui/game_connector'

describe GameWidget do
  attr_reader :widget

  let(:connector) { GameConnector.new }

  before :each do
    initialize_qt_runtime
    connector.create_game(:human_vs_human)
    @widget = GameWidget.new(connector)
  end

  it 'starts a new game when shown' do
    expect(connector).to receive(:start_game)
    widget.show
  end

  it 'reinitializes the grid when shown' do
    widget.buttons[0].setText('random text')

    widget.show

    expect(widget.buttons[0].text).to eq ''
  end

  it 'ends a game when hidden' do
    expect(connector).to receive(:end_game)
    widget.hide
  end

  it '#make_move sends the move to the connector' do
    allow(@widget).to receive(:sender).and_return(FakeSignal.new)

    widget.make_move
  end

  it 'updates the grid with game-board contents' do
    allow(connector).to receive(:board_state).and_return(['x', 'x', 'x',
                                                          'o', 'x', 'o',
                                                          'o', 'o', 'x'])

    widget.update_grid
    expect(widget.buttons[0].text).to eq 'x'
    expect(widget.buttons[6].text).to eq 'o'
  end

  it 'updates the buttons text with a player mark when clicking it' do
    first_player_mark = connector.game.players.first.mark
    widget.buttons[0].clicked()
    expect(widget.buttons[0].text).to eq first_player_mark
  end

  it 'does not update button texts after game is over' do
    allow(connector).to receive(:game_is_ongoing?).and_return(false)

    widget.buttons[0].clicked()
    widget.buttons[1].clicked()

    expect(widget.buttons[1].text).to be_nil
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  class FakeSignal
    def objectName
      move_index
    end

    def move_index
      '3'
    end
  end
end
