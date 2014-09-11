require 'qt'

require 'game_factory'
require 'gui/gui_player'

class GameWidget < Qt::Widget
  attr_accessor :connector, :game, :back_button, :status_label, :buttons

  slots :make_move, :init_widget, :show

  def initialize(connector, parent = nil)
    super(parent)

    @connector = connector
    @connector.add_observer(self)

    @buttons = []

    create_layout
  end

  def create_layout
    self.layout = Qt::VBoxLayout.new do |layout|
      @grid_layout = Qt::GridLayout.new
      layout.addLayout(@grid_layout)

      @status_label = Qt::Label.new 'status...'
      layout.addWidget(@status_label, 0, Qt::AlignCenter)

      @back_button = Qt::PushButton.new 'Back to Menu'
      layout.addWidget(@back_button)
    end
  end

  def create_grid
    clear_grid

    cell_count = connector.board_state.length
    side_length = Math.sqrt(cell_count).to_i

    (0..cell_count-1).each do |i|
      col = i % side_length
      row = i / side_length

      group_box = Qt::GroupBox.new

      l = Qt::VBoxLayout.new do |l|
        @buttons[i] = Qt::PushButton.new
        @buttons[i].setObjectName((i + 1).to_s)
        @buttons[i].setStyleSheet("border: 0; font-size: 60pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;")

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

  def show
    super

    connector.start_game
    create_grid
  end

  def hide
    super
    connector.end_game
  end

  def update
    update_grid
    update_status
  end

  def update_grid
    @buttons.each_with_index do |button, index|
      cell = connector.board_state[index]
      button.setText(cell)

      if cell == 'x'
        button.setStyleSheet("color: #EF8730; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;")
        disconnect(button, SIGNAL(:clicked), self, SLOT(:make_move))
      elsif cell == 'o'
        button.setStyleSheet("color: #5D4157; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;")
        disconnect(button, SIGNAL(:clicked), self, SLOT(:make_move))
      end
      button.update
    end

    if !connector.game_is_ongoing?
      @buttons.each do |button|
        disconnect(button, SIGNAL(:clicked),self, SLOT(:make_move))
      end
    end
  end

  def update_status
    @status_label.text = connector.status_text
  end

  def make_move
    location = sender.objectName.to_i
    @connector.make_move(location)
  end
end
