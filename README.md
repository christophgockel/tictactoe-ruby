# Tic Tac Toe

A single player Tic Tac Toe implementation with an unbeatable computer opponent written in Ruby.
There is a terminal UI available as well as a graphical one using Qt ([qtbindings](https://github.com/ryanmelt/qtbindings/)).

## Playing the Game
To play the game, you can chose one of the executables inside the `bin` directory.

- `bin/ttt` starts the terminal UI version
- `bin/ttt_gui` starts the graphical UI


## Requirements
* Ruby >= 2.0
* optional: [qtbindings gem](https://github.com/ryanmelt/qtbindings/)

## Bounty
There's a bounty set on [one line of code in the negamax implementation](https://github.com/christophgockel/tictactoe-ruby/blob/master/lib/computer_player.rb#L77). If you can tell me why it is not covered by SimpleCov when running the tests (or why it seems it isn't needed at all), I owe you... a beer?... a coffee?... We'll figure it out.

I'm out of ideas, but very interested in why this line seems to be unnecessary.