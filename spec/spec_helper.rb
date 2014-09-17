require 'simplecov'

require 'board_helper'

SimpleCov.start do
    add_filter '/spec/'
end

RSpec.configure do |c|
  c.include BoardHelper
end

shared_context 'a player' do
  it 'has a mark' do
    expect(subject).to respond_to(:mark)
  end

  it 'can provide the next move' do
    expect(subject).to respond_to(:next_move).with(1).arguments
  end
end

shared_context 'a game io object' do
  it 'can display a board' do
    expect(subject).to respond_to(:show_board).with(1).arguments
  end

  it 'can display an invalid move message' do
    expect(subject).to respond_to(:show_invalid_move_message).with(0).arguments
  end

  it 'can announce the next player' do
    expect(subject).to respond_to(:announce_next_player).with(1).arguments
  end

  it 'can announce the winner' do
    expect(subject).to respond_to(:announce_winner).with(1).arguments
  end

  it 'can announce a draw' do
    expect(subject).to respond_to(:announce_draw).with(0).arguments
  end
end
