require 'qt'

class GameSelectionWidget < Qt::Widget
  attr_reader :connector, :buttons, :board_size_buttons

  slots :set_game_type, :set_board_size

  def initialize(connector, parent = nil)
    super(parent)
    @connector = connector
    @board_size_buttons = {}
    @buttons = {}
    @board_size = :board_3x3

    self.layout = Qt::VBoxLayout.new do |layout|
      group_box = Qt::GroupBox.new('Board Size') do |box|
        box.layout = Qt::HBoxLayout.new do |box_layout|
          @board_size_buttons[:board_3x3] = Qt::RadioButton.new('3x3')
          @board_size_buttons[:board_3x3].setChecked true
          @board_size_buttons[:board_3x3].objectName = :board_3x3.to_s
          box_layout.addWidget(@board_size_buttons[:board_3x3])

          @board_size_buttons[:board_4x4] = Qt::RadioButton.new('4x4')
          @board_size_buttons[:board_4x4].objectName = :board_4x4.to_s
          box_layout.addWidget(@board_size_buttons[:board_4x4])
        end
      end
      layout.addWidget(group_box)

      group_box = Qt::GroupBox.new('Game Modes') do |box|
        box.layout = Qt::VBoxLayout.new do |box_layout|
          @buttons[:human_vs_human] = Qt::PushButton.new('Human vs. Human')
          @buttons[:human_vs_human].objectName = :human_vs_human.to_s
          box_layout.addWidget(@buttons[:human_vs_human])

          @buttons[:human_vs_computer] = Qt::PushButton.new('Human vs. Computer')
          @buttons[:human_vs_computer].objectName = :human_vs_computer.to_s
          box_layout.addWidget(@buttons[:human_vs_computer])

          @buttons[:computer_vs_human] = Qt::PushButton.new('Computer vs. Human')
          @buttons[:computer_vs_human].objectName = :computer_vs_human.to_s
          box_layout.addWidget(@buttons[:computer_vs_human])

          @buttons[:computer_vs_computer] = Qt::PushButton.new('Computer vs. Computer')
          @buttons[:computer_vs_computer].objectName = :computer_vs_computer.to_s
          box_layout.addWidget(@buttons[:computer_vs_computer])
        end
      end

      layout.addWidget(group_box, 1)
    end

    connect(@board_size_buttons[:board_3x3], SIGNAL(:clicked), self, SLOT(:set_board_size))
    connect(@board_size_buttons[:board_4x4], SIGNAL(:clicked), self, SLOT(:set_board_size))

    connect(@buttons[:human_vs_human], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:human_vs_computer], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:computer_vs_human], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:computer_vs_computer], SIGNAL(:clicked), self, SLOT(:set_game_type))
  end

  def set_game_type
    @game_type = sender.objectName.to_sym

    connector.create_game(@game_type, @board_size)
  end

  def set_board_size
    @board_size = sender.objectName.to_sym
  end
end
