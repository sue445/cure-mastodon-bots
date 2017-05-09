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

    before do
      allow_any_instance_of(App).to receive(:precure_programs) { [] } # rubocop:disable RSpec/AnyInstance
    end

    it { should be_ok }
  end
end
