begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

require "rollbar/rake_tasks"

task :environment do
  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  end
end

namespace :bot do
  desc "Post precure birthday when today is someone's birthday"
  task :birthday => :environment do
    require_relative "./birthday_bot"
    BirthdayBot.new.perform
  end

  desc "Sample precure"
  task :sample => :environment do
    require_relative "./sample_bot"
    SampleBot.new.perform
  end

  desc "Post precure program after 10 mitutes from now"
  task :on_air => :environment do
    require_relative "./on_air_bot"
    OnAirBot.new.perform
  end
end
