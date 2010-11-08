STDOUT.sync = true

require 'fileutils'
require 'active_record'
require 'active_support/core_ext/hash/reverse_merge'
require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'core_ext/ruby/module/option_reader'

module Adva
  module Generators
    class App
      DEFAULT_OPTIONS = {
        :source    => File.expand_path('../../../../..', __FILE__),
        :target    => File.expand_path('.'),
        :template  => File.expand_path('../templates/app/app_template.rb', __FILE__),
        :engines   => [:all],
        :resources => false,
        :migrate   => false,
        :bundle    => false,
        :force     => false
      }

      def initialize(name, options = {}, &block)
        @options = options.reverse_merge!(DEFAULT_OPTIONS)
        @name    = name || File.basename(source)
        raise ArgumentError, "#{source.inspect} is not a directory" unless File.directory?(source)
      end

      def invoke
        if force? || build?
          build
          generate_resources  if generate_resources?
          bundle              if bundle?
          load_environment    if block_given? || migrate?
          exec(&block)        if block_given?
          install
          migrate             if migrate?
        else
          load_environment
        end
      end

      protected

        attr_reader :name
        option_reader :source, :target, :template, :engines, :resources, :migrate, :bundle, :force

        def root
          "#{target}/#{name}"
        end

        def build
          puts "Building application ..."
          FileUtils.rm_r(root) if File.exists?(root)
          in_root do
            options = force? || ENV.key?('REGENERATE_APP') ? ['-f'] : []
            generator = Rails::Generators::AppGenerator.new([root], options, :shell => shell)
            generator.invoke_all
            generator.apply(template, :source => Pathname.new(source))
            FileUtils.cp("#{source}/Thorfile", "#{root}/Thorfile")
          end
        end

        def install
          puts "Installing adva engines ..."
          in_root { Adva::Generators::Install.new(engines).invoke }
        end

        def migrate
          puts "Migrating database ..."
          in_root { ActiveRecord::Migrator.migrate('db/migrate/') }
        end

        def bundle
          puts "Bundling gems ..."
          in_root { run 'bundle install' }
        end

        def load_environment
          puts "Loading environment ..."
          in_root { require "config/environment" }
        end

        def generate_resources
          puts "Generating resources ..."
          FileUtils.cp(resources, "#{root}/config/resource_layout.rb")
          run "rails generate resource_layout --generator=ingoweiss:scaffold"
        end

        def exec(&block)
          in_root { self.instance_exec(&block) }
        end

        def build?
          ENV.key?('REGENERATE_APP') || !exists?
        end

        def generate_resources?
          resources && File.exists?(resources)
        end

        def exists?
          File.exists?(root)
        end

        def in_root(&block)
          FileUtils.mkdir_p(root) unless File.directory?(root)
          Dir.chdir(root) { yield }
        end

        def run(command, &block)
          in_root { system "#{command}" }
        end

        def shell
          Thor::Shell::Color.new
        end
    end
  end
end
