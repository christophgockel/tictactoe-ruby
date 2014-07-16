require 'game'
require 'board'
require 'io'
require 'human_player'
require 'computer_player'


cli_io = CommandLineIO.new

x = HumanPlayer.new('x')
o = ComputerPlayer.new('o')

begin
  game = Game.new([x, o], Board.new, cli_io)

  puts 'winner is: ' + game.start
rescue Interrupt
end
