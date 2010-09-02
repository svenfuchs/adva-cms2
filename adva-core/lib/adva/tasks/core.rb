require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'
require 'rails/engine'

module Adva
  module Tasks
    class App < Thor::Group
      namespace 'adva:app'
      desc 'Create a new adva app'
      argument :name, :required => false
      class_option :target,   :required => false
      class_option :engines,  :required => false, :type => :array
      class_option :install,  :required => false, :type => :boolean
      class_option :migrate,  :required => false, :type => :boolean, :default => true
      class_option :template, :required => false
      class_option :force,    :required => false, :type => :boolean, :default => true

      def perform
        require 'adva/generators/app'
        Adva::Generators::App.new(name, symbolized_options).invoke
      end
    end

    class Engine < Thor::Group
      namespace 'adva:engine'
      desc 'Create an adva engine'
      argument :name

      def perform
        require 'adva/generators/engine'
        Adva::Generators::Engine.new(name, symbolized_options).invoke_all
      end
    end

    class Install < Thor::Group
      namespace 'adva:install'
      desc 'Install adva engines'

      def install
        Adva.engines.each do |engine|
          engine.copy_migrations.each do |path|
            say_status 'copy migration', File.basename(path)
          end
        end
      end
    end
  end
end

