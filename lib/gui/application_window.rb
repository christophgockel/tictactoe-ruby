require 'qt'

require 'gui/game_selection_widget'
require 'gui/game_widget'
require 'gui/game_connector'

class ApplicationWindow < Qt::Widget
  slots :display_menu, :start_game

  def initialize(parent = nil)
    super(parent)

    connector = GameConnector.new
    self.window_title = connector.window_title

    @selection_widget = GameSelectionWidget.new(connector, self)
    @game_widget = GameWidget.new(connector, self)

    self.layout = Qt::VBoxLayout.new

    self.layout.addWidget @selection_widget
    self.layout.addWidget @game_widget

    @selection_widget.show
    @game_widget.hide

    self.setFixedSize(330, 300);

    connect_signals
  end

  def connect_signals
    GameFactory.available_game_types.each do |key, _|
      connect(@selection_widget.game_type_buttons[key], SIGNAL(:clicked), self, SLOT(:start_game))
    end

    connect(@game_widget.back_button, SIGNAL(:clicked), self, SLOT(:display_menu))
  end

  def start_game
    display_game_widget
  end

  def display_game_widget
    @selection_widget.hide
    @game_widget.show
    self.setFixedSize(330, 400);
  end

  def display_menu
    @selection_widget.show
    @game_widget.hide
    self.setFixedSize(330, 300);
  end
end
