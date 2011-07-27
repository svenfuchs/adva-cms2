require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportModelBlogTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "has Blog attributes" do
      setup_file 'blog.yml', YAML.dump(:name => 'Blog name')
      blog = Blog.new(import_dir.join('blog.yml'))
      expected = { :type => 'Blog', :name => 'Blog name', :slug => 'blog-name' }
      assert_equal expected, blog.attributes
    end

    test "creates a new Blog record" do
      setup_file '2010/10/10/post.yml'
      blog = Blog.new(import_dir)
      expected = { 'type' => 'Blog', 'name' => 'Home', 'slug' => 'home' }
      assert_equal expected, blog.updated_record.attributes.slice('type', 'name', 'slug')
    end

    test "finds and updates a Blog record corresponding to a Blog source" do
      setup_file '2010/10/10/post.yml'
      setup_root_blog_record
      blog = Blog.new(import_dir)
      assert blog.record.persisted?
    end

    test "adds categories" do
      setup_file '2010/10/10/post.yml', YAML.dump(:categories => 'foo, bar')
      blog = Blog.new(Adva::Static::Import::Source.recognize([import_dir]).first)
      assert_equal %w(foo bar), blog.categories.map(&:name)
    end
  end
end
