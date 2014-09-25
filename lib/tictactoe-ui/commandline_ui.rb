module TicTacToeUI
  class CommandlineUI
    attr_reader :display

    def initialize(display)
      @display = display
    end

    def ask_for_board_size(sizes)
      display.show_board_sizes(sizes)
      request_option(sizes)
    end

    def ask_for_game_mode(modes)
      display.show_game_modes(modes)
      request_option(modes)
    end

    def play(game)
      while game.is_playable?
        game.play_next_round
      end
    end

    private

    def request_option(list_of_options)
      choice = nil
      loop do
        choice = display.prompt_for_choice
        break if (1..list_of_options.length).include? choice
      end
      choice - 1
    end
  end
end
