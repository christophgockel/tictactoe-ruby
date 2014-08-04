require 'qt'

require 'game_factory'
require 'gui/gui_player'

class GameWidget < Qt::Widget
  attr_accessor :connector, :game, :back_button, :status_label

  slots :make_move, :init_widget, :show

  def initialize(connector, parent = nil)
    super(parent)

    @connector = connector
    @labels = []

    self.layout = Qt::GridLayout.new do |layout|
      (0..8).each do |i|
        col = i % 3
        row = i / 3

        group_box = Qt::GroupBox.new

        l = Qt::VBoxLayout.new do |l|
          @labels[i] = Qt::PushButton.new
          @labels[i].setObjectName (i + 1).to_s
          @labels[i].setStyleSheet "color: blue; font-size: 38pt; border: 0px; width: 100%; height: 100%;"

          l.addWidget(@labels[i])
          connect(@labels[i], SIGNAL(:clicked), self, SLOT(:make_move))
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

  def init_widget

  end

  def show
    super
    reinit_grid
  end

  def reinit_grid
      (0..8).each do |i|
          @labels[i].setText ''

          connect(@labels[i], SIGNAL(:clicked), self, SLOT(:make_move))
      end
      @status_label.setText ''
  end

  def update_grid
    connector.game.board.rows.flatten.each_with_index do |cell, index|
      @labels[index].setText(cell)

      if cell == 'x' # @marks[:player_one]
        @labels[index].setStyleSheet "color: #EF8730; font-size: 40pt; font-family: Arial Black; border: 0px; width: 100%; height: 100%;"
        disconnect(@labels[index], SIGNAL(:clicked),self, SLOT(:make_move))
      elsif cell == 'o' #@marks[:player_two]
        @labels[index].setStyleSheet "color: #5D4157; font-size: 40pt; font-family: Arial Black; border: 0px; width: 100%; height: 100%;"
        disconnect(@labels[index], SIGNAL(:clicked),self, SLOT(:make_move))
      end
    end

    if !connector.game_is_ongoing?
      (0..8).each do |index|
        disconnect(@labels[index], SIGNAL(:clicked),self, SLOT(:make_move))
      end
    end
  end

  def update_status
    @status_label.text = connector.status_text
  end

  def make_move
    connector = @connector
    name = sender.objectName.to_i


    timer = Qt::Timer.new(window)

    block = Proc.new {
      begin
        connector.make_move(name)
        update_grid
        update_status
      rescue Game::Over
        timer.stop
      ensure
        if connector.game_is_ongoing? == false
          disconnect(timer, SIGNAL("timeout()"))
          timer.stop
        end
      end
    }

    invoke = Qt::BlockInvocation.new(timer, block, "invoke()")
    connect(timer, SIGNAL("timeout()"), invoke, SLOT("invoke()"))
    timer.start(1)
  end
end
