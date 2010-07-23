require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty --tags ~@wip"
end

desc 'Run all adva tests'
task :test_all do
  STDOUT.sync = true
  system('ruby test/all.rb')
  state = $?

  if state.exited? and state.exitstatus != 0
     exit state.exitstatus
  end
end

task :default => [:features, :test_all]

