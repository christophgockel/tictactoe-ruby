require 'qt'
require 'game_factory'

class GameSelectionWidget < Qt::Widget
  attr_reader :game_type_buttons, :board_size_buttons

  slots :set_game_type, :set_board_size

  def initialize(parent = nil)
    super(parent)

    @board_size_buttons = {}
    @game_type_buttons = {}

    self.layout = Qt::VBoxLayout.new do |layout|
      group_box = Qt::GroupBox.new('Board Size') do |box|
        box.layout = Qt::HBoxLayout.new do |box_layout|
          GameFactory.available_board_sizes.each do |key, description|
            @board_size_buttons[key] = Qt::RadioButton.new(description)
            @board_size_buttons[key].objectName = key.to_s

            if @board_size_buttons.length == 1
              @board_size_buttons[key].setChecked(true)
              @board_size_buttons[key].setFocus
            end

            box_layout.addWidget(@board_size_buttons[key])
          end
        end
      end
      layout.addWidget(group_box)

      group_box = Qt::GroupBox.new('Game Types') do |box|
        box.layout = Qt::VBoxLayout.new do |box_layout|
          GameFactory.available_game_types.each do |key|
            @game_type_buttons[key] = Qt::PushButton.new(game_type_text(key.to_s))
            @game_type_buttons[key].objectName = key.to_s

            box_layout.addWidget(@game_type_buttons[key])
          end
        end
      end

      layout.addWidget(group_box, 1)
    end

    @board_size_buttons.each do |key, button|
      connect(button, SIGNAL(:clicked), self, SLOT(:set_board_size))
    end

    @game_type_buttons.each do |key, button|
      connect(button, SIGNAL(:clicked), self, SLOT(:set_game_type))
    end
  end

  def set_game_type
    @game_type = sender.objectName.to_sym
  end

  def set_board_size
    @board_size = sender.objectName.to_sym
  end

  def game_type_text(game_type)
    game_type.split('_').map{ |e| e.capitalize}.join(' vs. ')
  end
end
