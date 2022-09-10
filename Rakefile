begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError # rubocop:disable Lint/SuppressedException
end

begin
  require "dotenv"
  Dotenv.load
rescue LoadError # rubocop:disable Lint/SuppressedException
end

task :environment do
  ENV["RACK_ENV"] ||= "development"
  Bundler.require(:default, ENV["RACK_ENV"])
end

namespace :bot do
  desc "Post precure birthday when today is someone's birthday"
  task :birthday => :environment do
    require_relative "./lib/birthday_bot"
    BirthdayBot.new.perform
  end

  desc "Sample precure"
  task :sample => :environment do
    require_relative "./lib/sample_bot"
    SampleBot.new.perform
  end

  desc "Post precure program after 10 mitutes from now"
  task :on_air => :environment do
    require_relative "./lib/on_air_bot"
    OnAirBot.new.perform
  end

  desc "Post precure program onair today"
  task :today_on_air => :environment do
    require_relative "./lib/today_on_air_bot"
    TodayOnAirBot.new.perform
  end
end
