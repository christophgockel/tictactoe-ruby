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

    self.layout = Qt::GridLayout.new do |layout|
      (0..8).each do |i|
        col = i % 3
        row = i / 3

        group_box = Qt::GroupBox.new

        l = Qt::VBoxLayout.new do |l|
          @buttons[i] = Qt::PushButton.new
          @buttons[i].setObjectName (i + 1).to_s
          @buttons[i].setStyleSheet "border: 0; font-size: 60pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;"

          l.addWidget(@buttons[i])
          connect(@buttons[i], SIGNAL(:clicked), self, SLOT(:make_move))
        end

        group_box.layout = l
        layout.addWidget group_box, row, col
      end

      @status_label = Qt::Label.new 'status...'
      layout.addWidget @status_label, 3, 0, 1, 3, Qt::AlignCenter

      @back_button = Qt::PushButton.new 'Back to Menu'
      layout.addWidget @back_button, 4, 0, 1, 3, Qt::AlignHCenter
    end
  end

  def show
    super

    init_grid
    connector.start_game
  end

  def hide
    super
    connector.end_game
  end

  def update
    update_grid
    update_status
  end

  def init_grid
    (0..8).each do |i|
      @buttons[i].setText ''
      connect(@buttons[i], SIGNAL(:clicked), self, SLOT(:make_move))
    end

    @status_label.setText ''
  end

  def update_grid
    connector.board_state.each_with_index do |cell, index|
      @buttons[index].setText(cell)


      if cell == 'x'
        @buttons[index].setStyleSheet "color: #EF8730; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;"
        disconnect(@buttons[index], SIGNAL(:clicked), self, SLOT(:make_move))
      elsif cell == 'o'
        @buttons[index].setStyleSheet "color: #5D4157; border: 0; font-size: 40pt; font-family: Arial Black; text-align: center; width: 100%; height: 100%;"
        disconnect(@buttons[index], SIGNAL(:clicked), self, SLOT(:make_move))
      end
    end

    if !connector.game_is_ongoing?
      (0..8).each do |index|
        disconnect(@buttons[index], SIGNAL(:clicked),self, SLOT(:make_move))
      end
    end
  end

  def update_status
    @status_label.text = connector.status_text
  end

  def make_move
    location = sender.objectName.to_i
    @connector.make_move location
  end
end
