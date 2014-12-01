describe "Application 'jam-session-demo'" do

  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    expect(@app.windows.size).to eq 1
  end

end
