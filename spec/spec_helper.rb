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
