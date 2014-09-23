require 'spec_helper'

require 'game_factory'
require 'gui/game_widget'

describe GameWidget do
  subject { @widget }
  it_should_behave_like 'a game io object'
  attr_reader :widget

  before :each do
    initialize_qt_runtime
    @widget = GameWidget.new()
    widget.game = double.as_null_object
    widget.grid_size = 3
    widget.create_grid
  end

  it 'reinitializes the grid when shown' do
    expect(widget).to receive(:create_grid)

    widget.show
  end

  it 'announces next player' do
    widget.announce_next_player('A')
    expect(widget.status_label.text).to include 'Next move'
  end

  it 'announces the winner' do
    widget.announce_winner('B')
    expect(widget.status_label.text).to include 'Winner'
  end

  it 'announces a draw' do
    widget.announce_draw
    expect(widget.status_label.text).to include 'draw'
  end

  context 'move handling' do
    it 'triggers moves by clicking buttons' do
      expect(widget).to receive(:make_move)

      widget.game = GameFactory.create_game(:human_human, :board_3x3, double.as_null_object)
      widget.buttons[0].click
    end

    it 'uses buttons to provide the next move' do
      allow(widget).to receive(:sender).and_return(FakeSignal.new)
      widget.make_move

      expect(widget.next_move).to eq 3
    end

    it 'can provide a move when a button is clicked' do
      allow(widget).to receive(:sender).and_return(FakeSignal.new)
      widget.buttons[0].click

      expect(widget.can_provide_next_move?).to eq true
    end

    it 'can not provide a move until a button is clicked' do
      expect(widget.can_provide_next_move?).to eq false
    end
  end

  context 'grid display' do
    before :each do
      widget.game = GameFactory.create_game(:human_human, :board_3x3, double.as_null_object)
    end

    it 'creates a grid of buttons when shown' do
      widget.show
      expect(widget.buttons.length).to eq 9
    end

    it 'removes buttons when hidden' do
      widget.hide
      expect(widget.buttons.length).to eq 0
    end

    it 'displays board content in button texts' do
      widget.create_grid
      widget.show_board(board_with('xxxoooxxx'))

      expect(widget.buttons[0].text).to eq 'x'
    end
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  class FakeSignal
    def objectName
      move_index
    end

    def move_index
      '3'
    end
  end
end
