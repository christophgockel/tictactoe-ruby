require 'game'
require 'player'
require 'opponent'
require 'board'
require 'io'


cli_io = CommandLineIO.new
automatic_input = AutomaticInput.new

x = Player.X(cli_io)
o = Player.O(automatic_input)

begin
  game = Game.new([x, o], Board.new, cli_io)

  puts 'winner is: ' + game.start
rescue Interrupt
end
