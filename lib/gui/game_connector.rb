require 'game_factory'
require 'gui/gui_player'

class GameConnector
  attr_accessor :window_title, :status_text
  attr_reader :game, :human_player

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
    end
  end

  def game_is_ongoing?
    game.is_ongoing?
  end

  def make_move(move)
    @game_process.play(move)
    update_status
  end

  def update_status
    if game.winner != ''
    @status_text = "Winner is: #{game.winner}."
    elsif game_is_ongoing? == false
      @status_text = 'Game ended in draw.'
    else
      @status_text = ''
    end
  end
end

class ComputerVsComputerGame
  attr_reader :game

  def initialize(game, connector)
    @game = game
    @connector = connector
  end

  def play(move)
    game.play_next_round
  end
end

class HumanVsComputerGame
  attr_reader :game

  def initialize(game, connector)
    @game = game
    @connector = connector
    @player = game.players.first
  end

  def play(move)
    @player.next_move_to_play = move
    game.play_next_round
#    game.play_next_round
  end
end

class ComputerVsHumanGame
  attr_reader :game

  def initialize(game, connector)
    @game = game
    @connector = connector
    @player = game.players.first
  end

  def play(move)
    @player.next_move_to_play = move if move
    game.play_next_round
#    game.play_next_round
  end
end

class HumanVsHumanGame
  attr_reader :game

  def initialize(game, connector)
    @game = game
    @connector = connector
  end

  def play(move)
    game.players.first.next_move_to_play = move
    game.play_next_round
  end
end
