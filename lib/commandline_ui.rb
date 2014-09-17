require 'game_factory'

class CommandlineUI
  attr_reader :display, :game_modes, :game, :use_color

  def initialize(display)
    @display = display
    @game_modes = game_modes
    @game    = game
    @use_color = false
  end

  def ask_for_game_mode(modes)
    choice = nil
    display.show_game_modes(modes)
    loop do
      choice = display.prompt_for_choice
      break if (1..modes.length).include? choice
    end
    choice - 1
  end

  def play(game)
    while game.is_ongoing?
      game.play_next_round
    end
  end
end
