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
      class_option :engines, :required => false, :type => :array

      def install
        Adva::Generators::Install.new(symbolized_options(:engines)).invoke
      end
    end

    module Test
      module Cucumber
        def cucumber
          require 'cucumber'
          require 'cucumber/rake/task'

          options = self.options.map { |name, value| ["--#{name}", value.is_a?(String) ? value : nil] }.flatten.compact
          pattern = self.pattern.include?('features') ? self.pattern : "#{self.pattern}/features"
          ::Cucumber::Rake::Task::InProcessCucumberRunner.new([], options, Dir[pattern])
        end
      end

      class All < Thor::Group
        namespace 'test:all'
        desc 'run all features and tests'
        class_option :rebuild, :required => false

        include Cucumber

        def all
          ENV['REGENERATE_APP'] = 1 if rebuild
          Rails.env = 'test'
          cucumber.run
          Dir['**/test/**/*_test.rb'].each { |file| require file }
        end
      end

      class Features < Thor::Group
        namespace 'test:features'
        desc 'run cucumber features'
        argument     :pattern,   :required => false, :default => '**/features'
        class_option :rebuild,   :required => false, :default => false
        class_option :format,    :required => false, :default => 'pretty'
        class_option :tags,      :required => false, :default => '~@wip'
        class_option :name,      :required => false
        class_option :exclude,   :required => false
        class_option :backtrace, :required => false, :default => true
        class_option :wip,       :required => false

        include Cucumber

        def features
          ENV['REGENERATE_APP'] = 1 if options['rebuild']
          Rails.env = 'test'
          cucumber.run
        end
      end

      class Unit < Thor::Group
        namespace 'test:unit'
        desc 'run tests'
        argument     :pattern, :required => false, :default => '**/test/**/*_test.rb'
        class_option :name,    :required => false, :desc => 'Runs tests matching NAME. Patterns may be used.' # Runs tests matching NAME.

        def unit
          Rails.env = 'test'
          Dir[pattern].each { |file| require file }
        end
      end
    end
  end
end

