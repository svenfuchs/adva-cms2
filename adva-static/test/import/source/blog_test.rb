require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSourceBlogTest < Test::Unit::TestCase
    include Adva::Static::Import::Source, TestHelper::Static

    def blog
      Site.new(import_dir).sections.first
    end

    test "given a root blog post file 2010/10/10/post.yml it recognizes a blog" do
      setup_file '2010/10/10/post.yml'
      assert blog.is_a?(Blog)
    end

    test "given a non-root blog post file blog/2010/10/10/post.yml it recognizes a blog" do
      setup_file 'blog/2010/10/10/post.yml'
      assert blog.is_a?(Blog)
    end

    test "given a root blog post file 2010/10/10/post.yml it recognizes a post" do
      setup_file '2010/10/10/post.yml'
      assert blog.posts.last.is_a?(Post)
    end

    test "given a non-root blog post file blog/2010/10/10/post.yml it recognizes a post" do
      setup_file 'blog/2010/10/10/post.yml'
      assert blog.posts.last.is_a?(Post)
    end

    test "given a file index.yml it and a root blog post file it recognizes a blog and reads the file" do
      setup_file '2010/10/10/post.yml'
      setup_file 'index.yml', YAML.dump(:name => 'name')

      assert blog.is_a?(Blog)
      assert_equal('name', blog.data.name)
    end

    test "given a file blog.yml it and a non-root blog post file it recognizes a blog and reads the file" do
      setup_file 'blog/2010/10/10/post.yml'
      setup_file 'blog.yml', YAML.dump(:name => 'name')

      assert blog.is_a?(Blog)
      assert_equal('name', blog.data.name)
    end

    test "given a file blog/index.yml it and a non-root blog post file it recognizes a blog and reads the file" do
      setup_file 'blog/2010/10/10/post.yml'
      setup_file 'blog/index.yml', YAML.dump(:name => 'name')

      assert blog.is_a?(Blog)
      assert_equal('name', blog.data.name)
    end

    test "categories returns the uniq categories list from all posts" do
      setup_root_blog
      assert_equal ['foo', 'bar'], blog.categories
    end

    test "data includes attributes and association data" do
      setup_root_page
      setup_root_blog
      assert_equal [:body, :categories, :name, :posts, :slug], blog.data.keys.map(&:to_s).sort.map(&:to_sym)
    end

    test "name: prefers a given :title attribute if present" do
      setup_files(['2010-10-10-post.yml', ''], ['index.yml', YAML.dump(:name => 'Blog name')])
      blog = Blog.new(import_dir)
      assert_equal 'Blog name', blog.name
    end

    test "name: uses 'home' for the title as a fallback for the root section" do
      setup_files(['2010-10-10-post.yml', ''])
      blog = Blog.new(import_dir)
      assert_equal 'Home', blog.name
    end

    test "name: uses the dirname as a source for the title as a fallback for a non-root section" do
      setup_files(['blog/2010-10-10-post.yml', ''])
      blog = Blog.new(import_dir.join('blog'))
      assert_equal 'Blog', blog.name
    end

    test "slug: prefers a given :slug attribute if present" do
      setup_files(['2010-10-10-post.yml', ''], ['index.yml', YAML.dump(:slug => 'blog-slug', :name => 'Blog name')])
      blog = Blog.new(import_dir)
      assert_equal 'blog-slug', blog.slug
    end

    test "slug: uses the title as a source for the slug as a fallback" do
      setup_files(['2010-10-10-post.yml', ''], ['index.yml', YAML.dump(:name => 'Blog name')])
      blog = Blog.new(import_dir)
      assert_equal 'blog-name', blog.slug
    end

    test "slug: uses 'home' as a the slug as a fallback for a root section" do
      setup_files(['2010-10-10-post.yml', ''])
      setup_files(['2010-10-10-post.yml', ''])
      blog = Blog.new(import_dir)
      assert_equal 'home', blog.slug
    end

    test "slug: uses the dirname as a source for the slug as a fallback for a non-root section" do
      setup_files(['blog/2010-10-10-post.yml', ''])
      blog = Blog.new(import_dir.join('blog'))
      assert_equal 'blog', blog.slug
    end
  end
end
