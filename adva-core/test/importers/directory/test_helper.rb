require File.expand_path('../../../test_helper', __FILE__)

require 'yaml'
require 'adva-blog'
require 'blog'
require 'post'
require 'user'
require 'adva/importers/directory'

Devise.setup do |config|
  require 'devise/orm/active_record'
  config.encryptor = :bcrypt
end

module Tests
  module Core
    module Importers
      module Directory
        module Setup
          attr_reader :root

          def setup
            @root = Adva::Importers::Directory::Path.new('/tmp/adva-static-test/import/rails-i18n.org')
            setup_import_directory
            super
          end

          def teardown
            FileUtils.rm_r(Pathname.new('/tmp/adva-static-test/import')) rescue nil
            super
          end

          def setup_import_directory
            FileUtils.mkdir_p(root)
            setup_dirs(%w(images javascripts stylesheets))
            setup_files(['config.ru', 'foo'])
          end

          def setup_root_blog
            setup_files(
              ['2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml', YAML.dump(:content => 'Welcome to the future')],
              ['2009/07/12/ruby-i18n-gem-hits-0-2-0.html', YAML.dump(:content => 'Ruby I18n hits 0.2.0')]
            )
          end

          def setup_non_root_blog
            setup_files(
              ['blog/2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml', YAML.dump(:content => 'Welcome to the future')],
              ['blog/2009/07/12/ruby-i18n-gem-hits-0-2-0.html', YAML.dump(:content => 'Ruby I18n hits 0.2.0')]
            )
          end

          def setup_root_page
            setup_files(
              ['index.yml', YAML.dump(:content => 'home')]
            )
          end
          
          def setup_non_root_page
            setup_files(
              ['contact.yml', YAML.dump(:content => 'contact')]
            )
          end

          def setup_dirs(paths)
            paths.each do |path|
              FileUtils.mkdir_p(root.join(path))
            end
          end

          def setup_files(*files)
            files.each do |path, content|
              FileUtils.mkdir_p(root.join(File.dirname(path)))
              File.open(root.join(path), 'w') { |f| f.write(content) }
            end
          end
        end
      end
    end
  end
end