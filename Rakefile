require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@wip"
end

task :default => [:features]

namespace :adva do
  desc 'Install Adva CMS'
  task :install do
    # require 'adva/core/tasks/install'
    # require 'adva/user/tasks/install'

    Adva::Core::Install.new.copy_migrations
    Adva::User::Install.new.copy_migrations
  end
end