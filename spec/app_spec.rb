describe App do
  include Rack::Test::Methods

  def app
    App
  end

  describe "GET /" do
    subject do
      get "/"
      last_response
    end

    it { should be_ok }
  end
end
