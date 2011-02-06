require 'core_ext/ruby/kernel/silence_stream'

module Adva
  class Static
    class Setup
      attr_reader :app, :root, :source, :target, :host, :title, :remote

      def initialize(options)
        @app    = options[:app] || Rails.application
        @root   = Pathname.new(options[:root] || Dir.pwd)
        @source = root.join(options[:source]  || 'import')
        @target = root.join(options[:target]  || 'export')
        @remote = options[:remote]
        @host   = options[:host]  || 'example.org'
        @title  = options[:title] || host

        Adva.out = StringIO.new('')
      end

      def run
        setup_directories
        initial_import_and_export
        setup_source_repository
        setup_export_repository
      end

      def setup_directories
        source.mkdir rescue Errno::EEXIST
        target.mkdir rescue Errno::EEXIST
        site = source.join('site.yml')
        File.open(site, 'w+') { |f| f.write(YAML.dump(:host => host, :title => title)) } unless site.exist?
      end

      def initial_import_and_export
        Import.new(:source => source).run
        Export.new(app, :target => target).run
      end

      def setup_source_repository
        root.join('.gitignore').rmtree rescue Errno::ENOENT
        root.join('.git').rmtree rescue Errno::ENOENT

        File.open(root.join('.gitignore'), 'w+') { |f| f.write('export') }

        Dir.chdir(root) do
          init_repository
          commit("#{host} source")
          checkout_branch('source')
          delete_branch('master')
          add_remote('source') if remote
        end
      end

      def setup_export_repository
        root.join('export/.git').rmtree rescue Errno::ENOENT

        Dir.chdir(target) do
          init_repository
          commit("#{host} export")
          add_remote('master') if remote
        end
      end

      protected

        def init_repository
          `git init`
        end

        def commit(message)
          `git add .`
          `git commit -am '#{message}'`
        end

        def checkout_branch(name)
          `git branch #{name}`
          `git checkout --quiet #{name}`
        end

        def delete_branch(name)
          `git branch -D #{name}`
        end

        def add_remote(branch)
          `git remote add origin #{remote} -t #{branch}`
        end
    end
  end
end
