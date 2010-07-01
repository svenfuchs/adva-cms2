require 'rake'
require 'thor'
require 'rails/generators'
require 'adva/core'

module Adva
  class Core
    class Tasks < Rails::Generators::Base
      namespace 'adva:core'
      source_root Adva::Core.root

      def install
        Adva.engines.each { |engine| engine.copy_migrations }
      end
    end
  end
end

namespace :adva do
  desc 'Install adva'
  task :install do
    Adva::Core::Tasks.new.install
  end
end