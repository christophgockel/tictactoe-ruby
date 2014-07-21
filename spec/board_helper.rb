require 'board'

module BoardHelper
  def mark_a
    'a'
  end

  def mark_b
    'b'
  end

  def board_with(contents, size = 3)
    board = Board.new(size)

    contents.split('').each_with_index do |symbol, index|
      board.set_move(index + 1, (symbol == ' ' ? nil : symbol))
    end

    board
  end

  def board_content(board)
    board.rows.flatten.map { |cell| cell.nil? ? ' ' : cell }.join('')
  end

  class Builder
    include BoardHelper

    attr_reader :player
    attr_accessor :board

    def initialize(player)
      @player = player
    end

    def in(board_state)
      @board = board_with(board_state)
      board.set_move(player.next_move(board), player.mark)

      board_content(board)
    end
  end
end
