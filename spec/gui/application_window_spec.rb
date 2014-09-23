require 'gui/application_window'

describe ApplicationWindow do
  attr_reader :application

  before :each do
    initialize_qt_runtime
    @application = ApplicationWindow.new
  end

  def initialize_qt_runtime
    Qt::Application.new(ARGV)
  end

  it 'contains selection widget' do
    expect(application.children.any? { |child| child.kind_of? GameSelectionWidget }).to eq true
  end

  it 'contains game widget' do
    expect(application.children.any? { |child| child.kind_of? GameWidget }).to eq true
  end

  it 'can switch to its game widget' do
    expect_any_instance_of(GameWidget).to receive(:show)
    expect_any_instance_of(GameSelectionWidget).to receive(:hide)

    application.display_game_widget
  end

  it 'can switch to its selection widget' do
    expect_any_instance_of(GameWidget).to receive(:hide)
    expect_any_instance_of(GameSelectionWidget).to receive(:show)

    application.display_menu
  end

  context '#start_game' do
    it 'displays the game widget' do
      allow(application).to receive(:sender).and_return(FakeSelectionSignal.new)
      expect_any_instance_of(GameWidget).to receive(:show)

      application.start_game
    end

    class FakeSelectionSignal
      def objectName
        'human_human'
      end
    end
  end
end
