describe 'GameViewController' do

  before do
      @gameViewController = UIApplication.sharedApplication.windows[0].rootViewController
  end

  describe "#loadView" do

    before do
      @gameViewController.loadView
    end

    it 'view is a SKView instance' do
      expect(@gameViewController.view.class).to be SKView
    end

    it 'view is configured to show frames per second' do
      expect(@gameViewController.view.showsFPS).to be_true
    end

    it 'view is configured to show node count' do
      expect(@gameViewController.view.showsNodeCount).to be_true
    end

    it 'view is configured to show draw count' do
      expect(@gameViewController.view.showsDrawCount).to be_true
    end

  end

end