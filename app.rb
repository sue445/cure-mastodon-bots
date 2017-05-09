begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

Bundler.require(:default, ENV["RACK_ENV"])

require "rollbar/middleware/sinatra"

class App < Sinatra::Base
  use Rollbar::Middleware::Sinatra

  get "/" do
    slim :index
  end
end
