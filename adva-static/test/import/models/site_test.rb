require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSiteTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "recognizes a Site importer from a site path (/site.yml)" do
      sources = [source('site.yml')]
      sites = Site.recognize(sources)
      assert sources.empty?
      assert_equal ['ruby-i18n.org'], sites.map(&:host)
    end

    test "has Site attributes (w/o a site.yml)" do
      root.join('site.yml').delete
      site = Site.new(source(''))
      expected = { :host => 'ruby-i18n.org', :name => 'ruby-i18n.org', :title => 'ruby-i18n.org',
        :sections_attributes => [{ :site_id => '', :type => 'Page', :path => 'home', :slug => 'home',
          :name => 'Home', :article_attributes => { :title => 'Home', :body  => '' } }] }
      assert_equal expected, site.attributes.except(:account)
    end

    test "has Site attributes (w/ an existing site.yml)" do
      site = Site.new(source(''))
      expected = { :host => 'ruby-i18n.org', :name => 'Ruby I18n', :title => 'Ruby I18n',
        :sections_attributes => [{ :site_id => '', :type => 'Page', :path => 'home', :slug => 'home',
          :name => 'Home', :article_attributes => { :title => 'Home', :body  => '' } }] }
      assert_equal expected, site.attributes.except(:account)
    end

    test "finds a Site model corresponding to a Site importer" do
      setup_site_record
      site = Site.new(source(''))
      assert_equal ::Site.find_by_host('ruby-i18n.org'), site.record
    end

    test "site.updated_record with a new root blog section" do
      setup_root_blog

      site = Site.new(source('')).updated_record
      site.save!

      blog = site.sections.first
      post = blog.posts.first

      assert site.valid?
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Blog', blog.class.name
      assert_equal 'Home', blog.name
      assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
    end

    test "site.updated_record with an existing root blog section" do
      setup_root_blog_record
      setup_root_blog

      site = Site.new(source('')).updated_record
      site.save!

      blog = site.sections.first
      post = blog.posts.first

      assert site.valid?
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Blog', blog.class.name
      assert_equal 'Home', blog.name
      assert_equal 'Ruby I18n Gem Hits 0 2 0', post.title
    end

    test "site.site with a new non_root blog section" do
      setup_non_root_blog

      site = Site.new(source('')).updated_record
      site.save!

      blog = site.sections.first
      post_1 = blog.posts.first
      post_2 = blog.posts.second

      assert site.valid?
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Blog', blog.class.name
      assert_equal 'Blog', blog.name
      assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post_1.title
      assert_equal 'Ruby I18n Gem Hits 0 2 0', post_2.title
    end

    test "site.site with an existing non_root blog section" do
      setup_non_root_blog_record
      setup_non_root_blog

      site = Site.new(source('')).updated_record
      site.save!

      blog = site.sections.last
      post_1 = blog.posts.first
      post_2 = blog.posts.second

      assert site.valid?
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Blog', blog.class.name
      assert_equal 'Blog', blog.name
      assert_equal 'Ruby I18n Gem Hits 0 2 0', post_1.title
      assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post_2.title
    end

    test "site.site with a new root page, a new non_root blog and a new non_root page section" do
      setup_root_page
      setup_non_root_blog
      setup_non_root_page

      site = Site.new(source('')).updated_record
      site.save!

      root = site.sections.first
      blog = site.sections.second
      post = blog.posts.first
      page = site.sections.third

      assert site.valid?
      assert_equal 'ruby-i18n.org', site.host
      assert_equal 'Blog', blog.class.name
      assert_equal 'Blog', blog.name
      assert_equal 'Welcome To The Future Of I18n In Ruby On Rails', post.title
    end
  end
end