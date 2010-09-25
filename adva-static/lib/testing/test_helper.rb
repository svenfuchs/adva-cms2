module TestHelper
  module Static
    def setup
      setup_import_directory
      super
    end
    
    def root
      @root ||= Pathname.new('/tmp/adva-static-test/import/ruby-i18n.org')
    end

    def teardown
      teardown_import_directory
      super
    end

    def request(path)
      Adva::Static::Import.new(:source => root).request_for(path)
    end

    def source(path)
      Adva::Static::Import::Source.new(path, root)
    end

    def setup_site_record
      Factory(:site, :host => 'ruby-i18n.org')
    end

    def setup_root_page_record
      setup_site_record
    end

    def setup_non_root_page_record
      site = setup_site_record
      site.pages.create!(:name => 'Contact')
    end

    def setup_root_blog_record
      site = setup_site_record
      site.pages.first.destroy

      site.blogs.create!(:name => 'Home', :posts_attributes => [
        { :title => 'Welcome to the future of I18n in Ruby on Rails', :body => 'Welcome to the future!', :created_at => '2008-07-31' }
      ])
    end

    def setup_non_root_blog_record
      site = setup_site_record
      site.blogs.create!(:name => 'Blog', :posts_attributes => [
        { :title => 'Welcome to the future of I18n in Ruby on Rails', :body => 'Welcome to the future!', :created_at => '2008-07-31' }
      ])
    end

    def setup_import_directory
      root.mkpath
      setup_dirs(%w(images javascripts stylesheets))
      setup_files(['config.ru', 'foo'], ['site.yml', YAML.dump(:host => 'ruby-i18n.org', :name => 'Ruby I18n', :title => 'Ruby I18n')])
    end

    def teardown_import_directory
      FileUtils.rm_r(root) rescue nil
    end

    def setup_root_blog
      setup_files(
        ['2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml', YAML.dump(:body => 'Welcome to the future')],
        ['2009/07/12/ruby-i18n-gem-hits-0-2-0.yml', YAML.dump(:body => 'Ruby I18n hits 0.2.0')]
      )
    end

    def setup_non_root_blog
      setup_files(
        ['blog/2008/07/31/welcome-to-the-future-of-i18n-in-ruby-on-rails.yml', YAML.dump(:body => 'Welcome to the future')],
        ['blog/2009/07/12/ruby-i18n-gem-hits-0-2-0.yml', YAML.dump(:body => 'Ruby I18n hits 0.2.0')]
      )
    end

    def setup_root_page
      setup_files(
        ['index.yml', YAML.dump(:name => 'Home', :body => 'home')]
      )
    end

    def setup_root_nested_page
      setup_files(
        ['home/nested.yml', YAML.dump(:body => 'nested under home')]
      )
    end

    def setup_non_root_page
      setup_files(
        ['contact.yml', YAML.dump(:body => 'contact')]
      )
    end

    def setup_non_root_nested_page
      setup_files(
        ['contact/nested.yml', YAML.dump(:body => 'nested under contact')]
      )
    end

    def setup_nested_page
      setup_files(
        ['contact/mailer.yml', YAML.dump(:body => 'contact mailer')]
      )
    end

    def setup_dirs(paths)
      paths.each do |path|
        FileUtils.mkdir_p(root.join(path))
      end
    end

    def setup_files(*files)
      files.each do |path, content|
        root.join(File.dirname(path)).mkpath
        File.open(root.join(path), 'w') { |f| f.write(content) }
      end
    end
  end
end