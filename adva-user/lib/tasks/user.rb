require 'rails/generators'

# TODO dry this up with adva/core/tasks

module Adva
  class User
    class Tasks < Rails::Generators::Base
      namespace 'adva:cms'
      source_root Adva::User.root
      
      def install
        Dir[Adva::User.root.join('db/migrate/*')].each do |source|
          copy_file(source.gsub(Adva::User.root.to_s, '.'))
        end
      end
    end
  end
end

namespace :adva do
  desc 'Install adva-user'
  task :install do
    Adva::User::Tasks.new.install
  end
end