class DelayedComputerPlayer
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def mark
    player.mark
  end

  def next_move(board)
    sleep(1)
    player.next_move(board)
  end
end
