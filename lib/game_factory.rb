require 'game'
require 'human_player'
require 'computer_player'

class GameFactory
  def self.create_game(type)
    if type == :human_vs_computer
      Game.new(HumanPlayer.new('x'), ComputerPlayer.new('o', 'x'))
    elsif type == :human_vs_human
      Game.new(HumanPlayer.new('x'), HumanPlayer.new('o'))
    elsif type == :computer_vs_human
      Game.new(ComputerPlayer.new('x', 'o'), HumanPlayer.new('o'))
    elsif type == :computer_vs_computer
      Game.new(ComputerPlayer.new('x', 'o'), ComputerPlayer.new('o', 'x'))
    end
  end
end
