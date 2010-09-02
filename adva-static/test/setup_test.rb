require File.expand_path('../test_helper', __FILE__)

module AdvaStatic
  class SetupTest < Test::Unit::TestCase
    class Application
      def call(env)
        case env['PATH_INFO']
        when '/'
          [200, {}, '<h1>Home</h1>']
        end
      end
    end

    attr_reader :root, :task
    
    def setup
      @root = Pathname.new('/tmp/adva-static-test')
      root.mkdir rescue Errno::EEXIST
      
      Devise.setup do |config|
        require 'devise/orm/active_record'
        config.encryptor = :bcrypt
      end
      
      options = {
        :app    => Application.new,
        :root   => root,
        :host   => 'ruby-i18n.org',
        :title  => 'Ruby I18n',
        :remote => 'git@github.com:svenfuchs/ruby-i18n.org.git'
      }
      @task = Adva::Static::Setup.new(options)
      @task.setup_directories
    end
    
    def teardown
      root.rmtree rescue Errno::ENOENT
    end
    
    test "creates an import directory" do
      assert File.directory?(root.join('import'))
    end

    test "creates an export directory" do
      assert File.directory?(root.join('export'))
    end
    
    test "creates an import/site.yml" do
      data = YAML.load_file(root.join('import/site.yml'))
      assert_equal 'ruby-i18n.org', data[:host]
      assert_equal 'Ruby I18n', data[:title]
    end
    
    test "does an initial import and export" do
      task.initial_import_and_export

      site = Site.first
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Ruby I18n', site.title

      assert File.file?(root.join('export/config.ru'))
      assert File.file?(root.join('export/index.html'))
    end
    
    test "initializes and commits to a git repository in the root directory and adds the remote" do
      task.setup_source_repository
      assert File.file?(root.join('.git/config'))
      assert_equal 'ref: refs/heads/source', File.read(root.join('.git/HEAD')).chomp
      assert File.read(root.join('.git/config')).include?('fetch = +refs/heads/source:refs/remotes/origin/source')
      assert_equal '[source] ruby-i18n.org source', Dir.chdir(root) { `git show-branch` }.chomp
    end
    
    test "initializes and commits to a git repository in the export directory and adds the remote" do
      task.initial_import_and_export
      task.setup_export_repository
      assert File.file?(root.join('export/.git/config'))
      assert_equal 'ref: refs/heads/master', File.read(root.join('export/.git/HEAD')).chomp
      assert File.read(root.join('export/.git/config')).include?('fetch = +refs/heads/master:refs/remotes/origin/master')
      assert_equal '[master] ruby-i18n.org export', Dir.chdir(root.join('export')) { `git show-branch` }.chomp
    end
  end
end
