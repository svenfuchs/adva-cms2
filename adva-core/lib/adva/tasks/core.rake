require 'rake'
require 'adva/tasks/core'

namespace :adva do
  desc 'Install adva'
  task :install do
    Adva::Tasks::Install.start
  end
end