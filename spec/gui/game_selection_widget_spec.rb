require 'gui/game_selection_widget'
require 'gui/game_connector'

describe GameSelectionWidget do
  attr_reader :selection_widget

  let(:connector) { GameConnector.new }

  before :each do
    initialize_qt_runtime
    @selection_widget = GameSelectionWidget.new(connector)

    allow(@selection_widget).to receive(:sender).and_return(FakeSignal.new)
  end

  it '#set_game_type creates a game in the connector' do
    expect(connector).to receive(:create_game)

    selection_widget.set_game_type
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  class FakeSignal
    def objectName
      game_type
    end

    def game_type
      'human_vs_human'
    end
  end
end
