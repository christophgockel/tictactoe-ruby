class CommandlineIO
  attr_reader :input, :output, :use_colors

  TEMPLATE_3X3 = <<-END.gsub(/^ {4}/, '')
     1 | 2 | 3
     --|---|--
     4 | 5 | 6
     --|---|--
     7 | 8 | 9
  END

  TEMPLATE_4X4 = <<-END.gsub(/^ {4}/, '')
     1  |  2  |  3  |  4
    ----|-----|-----|-----
     5  |  6  |  7  |  8
    ----|-----|-----|-----
     9  |  10 |  11 |  12
    ----|-----|-----|-----
     13 |  14 |  15 |  16
  END

  def initialize(input, output, options = {})
    @input = input
    @output = output
    @use_colors = options.fetch(:use_colors, false)
  end

  def show_board(board)
    clear_screen

    board_content = board.rows.flatten

    template = template_for(board)

    board_content.each_with_index do |cell, index|
      replacement = value_for(cell, index)

      if ! replacement.strip.empty?
        template = template.sub(/(?<= )#{index + 1}/, replacement)
      end
    end

    output.puts template
  end

  def show_invalid_move_message
    output.puts "Invalid move"
  end

  def show_game_modes(modes)
    output.puts "Available game modes:"

    modes.each_with_index do |mode, index|
      output.puts "  (#{index + 1}) #{mode_name(mode)}"
    end
  end

  def show_board_sizes(sizes)
    output.puts "Available board sizes:"

    sizes.each_with_index do |size_identifier, index|
      output.puts " (#{index + 1}) #{size_description(size_identifier)}"
    end
  end

  def announce_next_player(mark)
    output.puts "\nNext move for #{mark}: "
  end

  def announce_winner(mark)
    output.puts "Winner is: #{mark}"
  end

  def announce_draw
    output.puts 'Game ended in a draw.'
  end

  def prompt_for_choice
    output.puts 'Your choice: '
    input.gets.to_i
  end

  def next_move
    input.gets.to_i
  end

  def can_provide_next_move?
    true
  end

  private

  def template_for(board)
    board.size == 3 ? TEMPLATE_3X3.clone : TEMPLATE_4X4.clone
  end

  def clear_screen
    output.puts "\e[H\e[2J"
  end

  def value_for(cell, index)
    value = ''

    if index >= 9
      value = cell.to_s.ljust(2)
    else
      value = cell.to_s
    end

    value
  end

  def mode_name(mode)
    mode.to_s.split('_').map { |e| e.capitalize }.join(' vs. ')
  end

  def size_description(identifier)
    identifier.to_s.split('_').last
  end
end
