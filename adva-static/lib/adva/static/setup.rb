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
        @host   = options[:host]   || 'example.org'
        @title  = options[:title]  || host
        
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
        File.open(source.join('site.yml'), 'w+') do |f|
           f.write(YAML.dump(:host => host, :title => title))
        end
      end

      def initial_import_and_export
        Import::Directory.new(source).run
        Export.new(app, :target => target).run
      end
      
      def setup_source_repository
        root.join('.gitignore').rmtree rescue Errno::ENOENT
        root.join('.git').rmtree rescue Errno::ENOENT
        
        File.open(root.join('.gitignore'), 'w+') { |f| f.write('export') }
        
        Dir.chdir(root) do
          `git init`
          `git add .`
          `git commit -am '#{host} source'`
          `git branch source`
          `git checkout --quiet source`
          `git branch -D master`
          `git remote add origin #{remote} -t source` if remote
        end
      end
      
      def setup_export_repository
        root.join('export/.git').rmtree rescue Errno::ENOENT

        Dir.chdir(target) do
          `git init`
          `git add .`
          `git commit -am '#{host} export'`
          `git remote add origin #{remote} -t master` if remote
        end
      end
    end
  end
end