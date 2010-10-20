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
        Adva::Generators::Install.new(symbolized_options).invoke
      end
    end

    module Test
      module Cucumber
        def cucumber_args
          args = cucumber_options + cucumber_files
          args.flatten.compact
        end

        def cucumber_files
          paths = Adva.engines.map { |engine| engine.root.join('features/*.feature').to_s }
          paths = paths.select { |path| path.include?(pattern) } if pattern
          Dir["{#{paths.join(',')}}"].sort
        end

        def cucumber_pattern
          self.respond_to?(:pattern) ? self.pattern : ''
        end

        def cucumber_options
          # TODO submit a patch to Cucumber: programatically find out supported Cucumber options seems
          # close to impossible bc/ it immediately calls parse! on its options as soon they are defined.
          # see http://github.com/aslakhellesoy/cucumber/blob/master/lib/cucumber/cli/options.rb#L261
          options = self.options.reject { |name, value| name.include?('rebuild') }
          options.map { |name, value| ["--#{name}", value.is_a?(String) ? value : nil] }.flatten.compact
        end
      end

      class All < Thor::Group
        namespace 'test:all'
        desc 'run all features and tests'
        class_option :rebuild, :aliases => '-r', :required => false

        include Cucumber


        def all
          require 'cucumber'
          ENV['REGENERATE_APP'] = true if options['rebuild']
          Rails.env = 'test'
          passed = !::Cucumber::Cli::Main.execute(cucumber_args) # returns true on failure

          Dir['**/test/**/*_test.rb'].each { |file| require file }
          passed &= test_runner.run # returns true on pass

          exit(passed ? 0 : 1)
        end

        protected

          # GOSHHHH. maybe we really should switch to minitest.

          def test_runner
            require 'test/unit'
            ::Test::Unit::AutoRunner.new(false).tap do |runner|
              runner.collector = lambda { |r| test_collector.new.collect($0.sub(/\.rb\Z/, '')) }
            end
          end

          def test_collector
            require 'test/unit/collector/objectspace'
            require 'mocha/integration/test_unit'
            Class.new(::Test::Unit::Collector::ObjectSpace) do
              def collect(name=NAME)
                suite, sub_suites = ::Test::Unit::TestSuite.new(name), []
                @source.each_object(Class) do |klass|
                  if klass < ::Test::Unit::TestCase && klass != ::Cucumber::Rails::World
                    add_suite(sub_suites, klass.suite)
                  end
                end
                sort(sub_suites).each { |s| suite << s }
                suite
              end
            end
          end
      end

      class Features < Thor::Group
        namespace 'test:features'
        desc 'run cucumber features'
        argument :pattern, :required => false, :default => '/features'
        class_option :rebuild,   :aliases => '-r', :required => false, :default => false
        class_option :format,    :aliases => '-f', :required => false, :default => 'pretty'
        class_option :tags,      :aliases => '-t', :required => false, :default => '~@wip'
        class_option :name,      :aliases => '-n', :required => false
        class_option :exclude,   :aliases => '-e', :required => false
        class_option :backtrace, :aliases => '-b', :required => false, :default => true
        class_option :wip,       :aliases => '-w', :required => false

        include Cucumber

        def features
          require 'cucumber'
          ENV['REGENERATE_APP'] = 'true' if options['rebuild']
          Rails.env = 'test'

          passed = !::Cucumber::Cli::Main.execute(cucumber_args) # returns true on failure
          exit(passed ? 0 : 1)
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
          exit($1.exitstatus) if $1.exited? && $1.exitstatus != 0
        end
      end
    end
  end
end

