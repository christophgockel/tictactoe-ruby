require 'qt'

class GameSelectionWidget < Qt::Widget
  attr_reader :connector, :buttons

  slots :set_game_type

  def initialize(connector, parent = nil)
    super(parent)
    @connector = connector
    @buttons = {}

    self.layout = Qt::VBoxLayout.new do |layout|
      group_box = Qt::GroupBox.new('Board Size') do |box|
        box.layout = Qt::HBoxLayout.new do |box_layout|
          button = Qt::RadioButton.new('3x3')
          button.setChecked true
          box_layout.addWidget(button)

          button = Qt::RadioButton.new('4x4')
          box_layout.addWidget(button)
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

    connect(@buttons[:human_vs_human], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:human_vs_computer], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:computer_vs_human], SIGNAL(:clicked), self, SLOT(:set_game_type))
    connect(@buttons[:computer_vs_computer], SIGNAL(:clicked), self, SLOT(:set_game_type))
  end

  def set_game_type
    @game_type = sender.objectName.to_sym
    connector.create_game(@game_type)
  end
end
