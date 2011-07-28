require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportSourcePostTest < Test::Unit::TestCase
    include Adva::Static::Import::Source, TestHelper::Static

    def post
      Site.new(import_dir).sections.first.posts.last
    end

    test "given a root blog post file import/2010/10/10/post.yml it reads the post's data" do
      setup_file '2010/10/10/post.yml', YAML.dump(:body => 'body')
      assert_equal('body', post.data.body)
    end

    test "given a non-root blog post file import/blog/2010/10/10/post.yml it reads the post's data" do
      setup_non_root_blog
      assert_equal('body', post.data.body)
    end

    test "categories splits a given string by commas" do
      setup_file '2010/10/10/post.yml', YAML.dump(:categories => 'foo, bar')
      assert_equal ['foo', 'bar'], post.categories
    end

    test "data includes attributes and association data" do
      setup_file '2010/10/10/post.yml', YAML.dump(:filter => 'markdown', :body => 'body', :categories => 'foo, bar')
      assert_equal({ :title => 'Post', :slug => 'post',  :body => 'body', :filter => 'markdown', :published_at => DateTime.new(2010, 10, 10), :categories => ['foo', 'bar']}, post.data)
    end

    test "recognizes a Post importer from a slugged post path (/2010-10-10-post.html)" do
      paths = [import_dir.join('2010-10-10-post.html')]
      post = Post.recognize(paths).first
      assert paths.empty?
      assert_equal '2010-10-10-post.html', post.path.local.to_s
    end

    test "recognizes a Post importer from a nested directory post path (/2010/10/10/post.html)" do
      paths = [import_dir.join('2010/10/10/post.html')]
      post  = Post.recognize(paths).first
      assert paths.empty?
      assert_equal '2010/10/10/post.html', post.path.local.to_s
    end

    test "recognizes a Post importer from a mixed nested directory and slugged post path (/2010/10/10-post.html)" do
      path = import_dir.join('2010/10/10-post.html')
      paths = [path]
      post  = Post.recognize(paths).first
      assert paths.empty?
      assert_equal '2010/10/10-post.html', post.path.local.to_s
    end

    test "recognizes a Post importer from a mixed nested directory and slugged post path (/2010/10-10-post.html)" do
      paths = [import_dir.join('2010/10-10-post.html')]
      post  = Post.recognize(paths).first
      assert paths.empty?
      assert_equal '2010/10-10-post.html', post.path.local.to_s
    end

    test "when recognizing /2010/10/10/post.html it removes the subdirectories from the recognizable paths" do
      paths = [import_dir.join('2010'), import_dir.join('2010/10'), import_dir.join('2010/10/10'), import_dir.join('2010/10/10/post.html')]
      posts = Post.recognize(paths)
      assert !posts.empty?
      assert paths.empty?
    end

    test "title: prefers a given :title attribute if present" do
      setup_file '2010-10-10-post.yml', YAML.dump(:title => 'Post title')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      assert_equal 'Post title', post.title
    end

    test "title: uses the filename as a source for the slug as a fallback" do
      setup_file '2010-10-10-post-title-from-filename.yml'
      post = Post.new(import_dir.join('2010-10-10-post-title-from-filename.yml'))
      assert_equal 'Post Title From Filename', post.title
    end

    test "slug: prefers a given :slug attribute if present" do
      setup_file '2010-10-10-post.yml', YAML.dump(:slug => 'post-slug')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      assert_equal 'post-slug', post.slug
    end

    test "slug: uses the title as a source for the slug as a fallback" do
      setup_file '2010-10-10-post.yml', YAML.dump(:title => 'Post title')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      assert_equal 'post-title', post.slug
    end

    test "slug: uses the filename as a source for the slug as a fallback" do
      setup_file '2010-10-10-post-title-from-filename.yml'
      post = Post.new(import_dir.join('2010-10-10-post-title-from-filename.yml'))
      assert_equal 'post-title-from-filename', post.slug
    end

    test "permalink can be read from filenames matching blog/:year/:month/:day/:slug.* " do
      setup_file 'blog/2010/10/10/post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('blog/2010/10/10/post.yml')).permalink
    end

    test "permalink can be read from filenames matching blog/:year/:month/:day-:slug.* " do
      setup_file 'blog/2010/10/10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('blog/2010/10/10-post.yml')).permalink
    end

    test "permalink can be read from filenames matching blog/:year/:month-:day-:slug.* " do
      setup_file 'blog/2010/10-10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('blog/2010/10-10-post.yml')).permalink
    end

    test "permalink can be read from filenames matching blog/:year-:month-:day-:slug.* " do
      setup_file 'blog/2010-10-10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('blog/2010-10-10-post.yml')).permalink
    end

    test "permalink can be read from filenames matching :year/:month/:day/:slug.* " do
      setup_file '2010/10/10/post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('2010/10/10/post.yml')).permalink
    end

    test "permalink can be read from filenames matching :year/:month/:day-:slug.* " do
      setup_file '2010/10/10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('2010/10/10-post.yml')).permalink
    end

    test "permalink can be read from filenames matching :year/:month-:day-:slug.* " do
      setup_file '2010/10-10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('2010/10-10-post.yml')).permalink
    end

    test "permalink can be read from filenames matching :year-:month-:day-:slug.* " do
      setup_file '2010-10-10-post.yml'
      assert_equal %w(2010 10 10 post), Post.new(import_dir.join('2010-10-10-post.yml')).permalink
    end

    test "permalink_paths returns the path and all ancestors from the permalink" do
      assert_equal %w(2010 2010/10 2010/10/10 2010/10/10/post.yml), Post.new(import_dir.join('2010/10/10/post.yml')).permalink_paths.map(&:local).map(&:to_s)
    end

    test "adds arbitrary attributes from metadata" do
      setup_file '2010-10-10-post.yml', YAML.dump(:guid => '12345')
      assert_equal '12345', Post.new(import_dir.join('2010-10-10-post.yml')).data.guid
    end
  end
end


