module TestHelper
  module Static
    def setup
      import_dir.mkpath
      super
    end

    def teardown_import_directory
      import_dir.rmtree rescue nil
    end

    def teardown_export_directory
      export_dir.rmtree rescue nil
    end

    def import_dir
      Adva::Static::Import::Source::Path.new('/tmp/adva-static-test/import')
    end

    def export_dir
      Pathname.new('/tmp/adva-static-test/export')
    end

    def teardown
      teardown_import_directory
      super
    end

    def setup_site_record
      Factory(:site, :host => 'ruby-i18n.org')
    end

    def setup_root_page_record
      Site.first || setup_site_record
    end

    def setup_non_root_page_record
      site = Site.first || setup_site_record
      site.pages.create!(:name => 'Contact')
    end

    def setup_root_blog_record
      site = setup_site_record
      site.pages.first.destroy

      site.blogs.create!(:name => 'Home', :posts_attributes => [{ :title => 'Post', :body => 'body', :published_at => '2010-10-10' }])
    end

    def setup_non_root_blog_record
      site = setup_site_record
      site.blogs.create!(:name => 'Blog', :posts_attributes => [{ :title => 'Post', :body => 'body', :published_at => '2010-10-10' }])
    end

    def setup_import_directory
      import_dir.mkpath
      setup_dirs(%w(images javascripts stylesheets))
      setup_files(['config.ru', 'foo'], ['site.yml', YAML.dump(:host => 'ruby-i18n.org', :name => 'Ruby I18n', :title => 'Ruby I18n')])
    end

    def setup_site
      import_dir.mkpath
      setup_files(
        ['site.yml', YAML.dump(:host => 'ruby-i18n.org', :name => 'name', :title => 'title')]
      )
    end

    def setup_root_blog
      setup_files(
        ['2010/10/10/post.yml', YAML.dump(:filter => 'markdown', :body => 'body', :categories => 'foo, bar')],
        ['2010/10/09/hello-world.yml', YAML.dump(:filter => 'markdown', :body => 'hello world!')]
      )
    end

    def setup_non_root_blog
      setup_files(
        ['blog/2010/10/10/post.yml', YAML.dump(:filter => 'markdown', :body => 'body', :categories => 'foo, bar')],
        ['blog/2010/10/09/hello-world.yml', YAML.dump(:filter => 'markdown', :body => 'hello world!')]
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
      paths.each { |path| FileUtils.mkdir_p(import_dir.join(path)) }
    end

    def setup_files(*files)
      files.each { |path, content| setup_file(path, content) }
    end

    def setup_file(path, content = '')
      import_dir.join(File.dirname(path)).mkpath
      File.open(import_dir.join(path), 'w') { |f| f.write(content) }
    end

    def future
      Time.local(Time.now.year + 1, Time.now.month, Time.now.day)
    end
  end
end
