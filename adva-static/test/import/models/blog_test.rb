require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportBlogTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "recognizes a Blog importer from a non-root blog path (e.g. /blog.yml) when a post source is present" do
      setup_root_blog
      sources = [source('blog.yml'), source('blog/2010-10-10-post.yml')]
      blogs = Blog.recognize(sources)
      assert sources.empty?
      assert_equal ['blog'], blogs.map(&:path)
    end

    test "recognizes a Blog importer from a root blog path (e.g. /index.yml) when a post source is present" do
      setup_non_root_blog
      sources = [source('index.yml'), source('2010-10-10-post.yml')]
      blogs = Blog.recognize(sources)
      assert sources.empty?
      assert_equal ['home'], blogs.map(&:path)
    end

    test "has Blog attributes" do
      setup_non_root_blog
      blog = Blog.new(source('blog.yml'))
      expected = { :site_id => '', :type => 'Blog', :path => 'blog', :slug => 'blog',
        :name => 'Blog', :posts_attributes=>[
          { :section_id => '', :site_id => '', :title => 'Welcome To The Future Of I18n In Ruby On Rails',
            :body => 'Welcome to the future', :created_at => DateTime.new(2008, 7, 31) },
          { :section_id => '', :site_id => '', :title => 'Ruby I18n Gem Hits 0 2 0',
            :body => 'Ruby I18n hits 0.2.0', :created_at => DateTime.new(2009, 7, 12) }] }
      assert_equal expected, blog.attributes
    end

    test "finds a Blog model corresponding to a Blog importer (w/ an index blog)" do
      setup_root_blog_record
      blog = Blog.new(source('index.yml'))
      assert_equal ::Blog.find_by_path('home'), blog.record
    end

    test "finds a Blog model corresponding to a Blog importer (w/ a non-index blog)" do
      setup_non_root_blog_record
      blog = Blog.new(source('blog.yml'))
      assert_equal ::Blog.find_by_path('blog'), blog.record
    end

    test "prefers a :name metadata attribute over the file basename as a source for the slug" do
      setup_files(['index.yml', YAML.dump(:name => 'Blog')])
      blog = Blog.recognize([source('index.yml'), source('2010-10-10-post.yml')]).first
      assert_equal 'blog', blog.slug
    end

    test "prefers a :name metadata attribute over the file basename as a source for the name" do
      setup_files(['index.yml', YAML.dump(:name => 'Blog')])
      blog = Blog.recognize([source('index.yml'), source('2010-10-10-post.yml')]).first
      assert_equal 'Blog', blog.name
    end
  end
end
