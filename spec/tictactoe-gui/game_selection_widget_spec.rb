require 'tictactoe-gui/game_selection_widget'

describe TicTacToeGUI::GameSelectionWidget do
  attr_reader :selection_widget

  before :each do
    initialize_qt_runtime
    @selection_widget = described_class.new()
  end

  it '#set_game_type creates a game in the connector' do
    allow(@selection_widget).to receive(:sender).and_return(FakeGameSelectionSignal.new)

    selection_widget.set_game_type
  end

  it 'can select the board size' do
    allow(@selection_widget).to receive(:sender).and_return(FakeBoardSizeSelectionSignal.new)
    selection_widget.board_size_buttons[:board_3x3].click
    selection_widget.set_game_type
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  class FakeGameSelectionSignal
    def objectName
      'human_human'
    end
  end

  class FakeBoardSizeSelectionSignal
    def objectName
      'board_3x3'
    end
  end
end
