require 'qt'

require 'tictactoe/game'
require 'tictactoe/board'
require 'tictactoe/player_factory'

module TicTacToeGUI
  class ApplicationWindow < Qt::Widget
    slots :display_menu, :start_game

    def initialize(selection_widget, game_widget)
      super(nil)

      self.window_title = 'Tic Tac Toe'

      @selection_widget = selection_widget
      @game_widget = game_widget

      self.layout = Qt::VBoxLayout.new

      self.layout.addWidget @selection_widget
      self.layout.addWidget @game_widget

      @selection_widget.show
      @game_widget.hide

      self.setFixedSize(330, 300);

      connect_signals
    end

    def connect_signals
      TicTacToe::PlayerFactory.available_player_pairs.each do |key, _|
        connect(@selection_widget.game_type_buttons[key], SIGNAL(:clicked), self, SLOT(:start_game))
      end

      connect(@game_widget.back_button, SIGNAL(:clicked), self, SLOT(:display_menu))
    end

    def start_game
      board = TicTacToe::Board.create(@selection_widget.board_size)
      players = TicTacToe::PlayerFactory.create_pair(@selection_widget.game_type, @game_widget)
      @game_widget.game = TicTacToe::Game.new(players.first, players.last, board, @game_widget)

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
end
