require 'qt'

require 'gui/application_window'
require 'gui/game_selection_widget'
require 'gui/game_widget'

describe ApplicationWindow do
  attr_reader :application, :selection_widget, :game_widget

  before :each do
    initialize_qt_runtime
    @selection_widget = GameSelectionWidget.new
    @game_widget      = GameWidget.new
    @application      = ApplicationWindow.new(@selection_widget, @game_widget)
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  it 'can switch to its game widget' do
    expect(game_widget).to receive(:show)
    expect(selection_widget).to receive(:hide)

    application.display_game_widget
  end

  it 'can switch to its selection widget' do
    expect(game_widget).to receive(:hide)
    expect(selection_widget).to receive(:show)

    application.display_menu
  end

  context '#start_game' do
    it 'displays the game widget' do
      allow(application).to receive(:sender).and_return(FakeSelectionSignal.new)
      allow(selection_widget).to receive(:board_size).and_return(:board_3x3)
      allow(selection_widget).to receive(:game_type).and_return(:human_human)

      expect(game_widget).to receive(:show)

      application.start_game
    end

    class FakeSelectionSignal
      def objectName
        'human_human'
      end
    end
  end
end
