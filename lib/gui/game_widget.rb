require 'qt'

require 'player_factory'

class GameWidget < Qt::Widget
  attr_accessor :game, :back_button, :status_label, :buttons, :grid_size

  slots :make_move, :init_widget, :show

  INITIAL_STYLE  =                 'border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;'
  PLAYER_1_STYLE = 'color: #EF8730; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;'
  PLAYER_2_STYLE = 'color: #5D4157; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;'

  def initialize(parent = nil)
    super(parent)

    @buttons = []
    @next_move = 0

    create_layout
  end

  def show
    super

    create_grid
    play_game
  end

  def hide
    super
    clear_grid
    Thread.kill(@game_thread) if @game_thread
  end

  def game=(game)
    @game = game
    @grid_size = game.board.size
  end

  def create_layout
    self.layout = Qt::VBoxLayout.new do |layout|
      @grid_layout = Qt::GridLayout.new
      layout.addLayout(@grid_layout)

      @status_label = Qt::Label.new
      layout.addWidget(@status_label, 0, Qt::AlignCenter)

      @back_button = Qt::PushButton.new 'Back to Menu'
      layout.addWidget(@back_button)
    end
  end

  def create_grid
    clear_grid

    cell_count = grid_size * grid_size

    (0..cell_count-1).each do |i|
      col = i % grid_size
      row = i / grid_size

      group_box = Qt::GroupBox.new

      l = Qt::VBoxLayout.new do |l|
        @buttons[i] = Qt::PushButton.new
        @buttons[i].setObjectName((i + 1).to_s)
        @buttons[i].setStyleSheet(INITIAL_STYLE)

        l.addWidget(@buttons[i])
        connect(@buttons[i], SIGNAL(:clicked), self, SLOT(:make_move))
      end

      group_box.layout = l
      @grid_layout.addWidget(group_box, row, col)
    end
  end

  def clear_grid
    while grid_cell = @grid_layout.take_at(0)
      @grid_layout.removeWidget(grid_cell.widget)
      grid_cell.widget.deleteLater
    end

    @buttons.clear
  end

  def make_move
    @next_move = sender.objectName.to_i
    play_game
  end

  def next_move
    move = @next_move
    @next_move = 0

    move
  end

  def can_provide_next_move?
    @next_move != 0
  end

  def play_game
    return if !@game_thread.nil? && @game_thread.alive?

    @game_thread = Thread.new do
      begin
        while game.is_ongoing?
          game.play_next_round
        end
      end
    end
  end

  def show_board(board)
    return if @buttons.length == 0

    board.rows.flatten.each_with_index do |cell, index|
      button = @buttons[index]
      button.setText(cell)

      if cell == 'x'
        button.setStyleSheet(PLAYER_1_STYLE)
        disconnect(button, SIGNAL(:clicked), self, SLOT(:make_move))
      elsif cell == 'o'
        button.setStyleSheet(PLAYER_2_STYLE)
        disconnect(button, SIGNAL(:clicked), self, SLOT(:make_move))
      end
      button.update
    end
  end

  def show_invalid_move_message
  end

  def announce_next_player(mark)
    @status_label.text = "Next move for: #{mark}"
  end

  def announce_winner(mark)
    @status_label.text = "Winner: #{mark}"
  end

  def announce_draw
    @status_label.text = 'Game ended in a draw.'
  end
end
