describe "Application 'jam-session-demo'" do

  before do
    @app = UIApplication.sharedApplication
  end

  it 'has one window' do
    expect(@app.windows.size).to eq 1
  end

  describe 'UIWindow' do

    before do
      @window = @app.windows[0]
    end

    it 'bounds is set to UIScreen.mainScreen bounds' do
      expect(@window.bounds).to eq UIScreen.mainScreen.bounds
    end

    it 'root controller is GameViewController instance' do
      expect(@window.rootViewController.class).to be GameViewController
    end

    it 'is key window' do
      expect(@window.isKeyWindow).to be_true
    end

    it 'is visible' do
      expect(@window.isHidden).to be_false
    end

  end

end
