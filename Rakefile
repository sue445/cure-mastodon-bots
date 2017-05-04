begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

namespace :bot do
  desc "Post precure birthday when today is someone's birthday"
  task :birthday do
    require_relative "./birthday_bot"
    BirthdayBot.new.perform
  end

  desc "Sample precure"
  task :sample do
    require_relative "./sample_bot"
    SampleBot.new.perform
  end
end
