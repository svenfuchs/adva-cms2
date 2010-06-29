require 'rails/generators'

# TODO dry this up with adva/user/tasks

module Adva
  class Core
    class Tasks < Rails::Generators::Base
      namespace 'adva:core'
      source_root Adva::Core.root
      
      def install
        Dir[Adva::Core.root.join('db/migrate/*')].each do |source|
          copy_file(source.gsub(Adva::Core.root.to_s, '.'))
        end
      end
    end
  end
end

namespace :adva do
  desc 'Install adva-core'
  task :install do
    Adva::Core::Tasks.new.install
  end
end