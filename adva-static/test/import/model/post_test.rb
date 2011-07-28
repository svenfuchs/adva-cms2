require File.expand_path('../../test_helper', __FILE__)

module AdvaStatic
  class ImportModelPostTest < Test::Unit::TestCase
    include Adva::Static::Import::Model, TestHelper::Static

    test "has Post attributes" do
      setup_file '2010-10-10-post.yml', YAML.dump(:title => 'title', :body => 'body')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      expected = { :site_id => '', :section_id => '', :title => 'title', :body => 'body', :slug => 'title', :published_at => DateTime.new(2010, 10, 10) }
      assert_equal expected, post.attributes
    end

    test "creates a Post new record" do
      setup_file '2010-10-10-post.yml', YAML.dump(:title => 'title', :body => 'body')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      post.update!
      expected = { 'type' => 'Post', 'title' => 'title', 'body' => 'body', 'slug' => 'title', 'published_at' => DateTime.new(2010, 10, 10) }
      assert_equal expected, post.record.attributes.slice('type', 'title', 'body', 'slug', 'published_at')
    end

    test "finds a Post record corresponding to a Post source" do
      setup_root_blog_record
      setup_file '2010-10-10-post.yml', YAML.dump(:title => 'post', :body => 'body!')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      assert post.record.persisted?
    end

    test "adds arbitrary attributes from metadata" do
      setup_file '2010-10-10-post.yml', YAML.dump(:guid => '12345')
      post = Post.new(import_dir.join('2010-10-10-post.yml'))
      assert_equal '12345', post.attributes[:guid]
    end
  end
end
