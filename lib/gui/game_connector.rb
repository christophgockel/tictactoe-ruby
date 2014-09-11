require 'observer'
require 'game_factory'
require 'gui/gui_player'

class GameConnector
  include Observable

  attr_accessor :window_title, :status_text
  attr_reader :game, :human_player, :game_process

  def initialize
    GameFactory.human_player_class = GuiPlayer
    @window_title = 'Tic Tac Toe'
    @status_text  = ''
  end

  def create_game(game_type)
    @game = GameFactory.create_game(game_type)

    case game_type
    when :human_vs_human
      @game_process = HumanVsHumanGame.new(@game, self)
    when :human_vs_computer
      @game_process = HumanVsComputerGame.new(@game, self)
    when :computer_vs_computer
      @game_process = ComputerVsComputerGame.new(@game, self)
    when :computer_vs_human
      @game_process = ComputerVsHumanGame.new(@game, self)
    end
    @status_text  = ''

    @game
  end

  def game_is_ongoing?
    game.is_ongoing?
  end

  def board_state
    game.board.rows.flatten
  end

  def start_game
    update_status
    @game_process.start
  end

  def inform_observers
    changed
    notify_observers
  end

  def end_game
    @game_process.stop if @game_process
  end

  def make_move(move)
    @game_process.play(move)

    inform_observers
  end

  def update_status
    if game.winner != ''
      @status_text = "Winner is: #{game.winner}."
    elsif game_is_ongoing? == false
      @status_text = 'Game ended in draw.'
    else
      @status_text = "Next move for: #{game.players.first.mark}"
    end

    inform_observers
  end

  class HumanVsHumanGame
    attr_reader :game

    def initialize(game, connector)
      @game = game
      @connector = connector
    end

    def start
    end

    def stop
    end

    def play(move)
      game.players.first.next_move_to_play = move
      game.play_next_round
      @connector.update_status
    end
  end

  class HumanVsComputerGame
    attr_reader :game

    def initialize(game, connector)
      @game = game
      @connector = connector
      @player = game.players.first
    end

    def start
    end

    def stop
    end

    def play(move)
      play_human_move(move)
      play_computer_move
      @connector.update_status
    rescue Game::Over
      @connector.update_status
    end

    def play_human_move(move)
      @player.next_move_to_play = move
      game.play_next_round
    end

    def play_computer_move
      game.play_next_round
    end
  end

  class ComputerVsHumanGame
    attr_reader :game

    def initialize(game, connector)
      @game = game
      @connector = connector
      @player = game.players.last
    end

    def start
      @thread = Thread.new do
        game.play_next_round
        @connector.update_status
      end
    end

    def stop
      Thread.kill(@thread) if @thread
    end

    def play(move)
      play_human_move(move)
      play_computer_move
      @connector.update_status
    end

    def play_human_move(move)
      @player.next_move_to_play = move
      game.play_next_round
    end

    def play_computer_move
      game.play_next_round
    end
  end

  class ComputerVsComputerGame
    attr_reader :game
    attr_accessor :window

    def initialize(game, connector)
      @game = game
      @connector = connector
    end

    def start
      @thread = Thread.new do
        while game.is_ongoing?
          game.play_next_round
          @connector.update_status
        end
      end
    end

    def stop
      Thread.kill(@thread)
    end

    def play(move)
    end
  end
end
