require File.expand_path('../test_helper', __FILE__)

require 'adva/view/menu'

module AdvaCoreTests
  class MenuTest < Test::Unit::TestCase
    include TestHelper::Application
    include TestHelper::MinimalTemplate

    attr_reader :controller, :menu

    def setup
      @controller = Admin::PostsController.new
      @controller.request = request_for('/admin/sites/1/blogs/1/posts/new')

      @menu = Adva::View::Menu.new(view)
      @menu.locals = { :controller => @controller }

      super
    end

    test 'item uses the last part of a i18n key starting with a dot as a css class of the generated link' do
      assert_match /<a[^>]*class="bar"[^>]*>/, menu.item(:'.bar', 'http://example.com')
    end

    test 'item uses the last part of a dot separated i18n key as a css class of the generated link' do
      assert_match /<a[^>]*class="bar"[^>]*>/, menu.item(:'foo.bar', 'http://example.com')
    end

    test 'label uses the last part of a dot separated i18n key as a css class of the h4 tag' do
      assert_match /<h4[^>]*class="bar"[^>]*>/, menu.label(:'foo.bar')
    end

    test 'active_paths' do
      expected = %w(
        /
        /admin
        /admin/sites
        /admin/sites/1
        /admin/sites/1/blogs
        /admin/sites/1/blogs/1
        /admin/sites/1/blogs/1/posts
        /admin/sites/1/blogs/1/posts/new
      )
      assert_equal expected, menu.send(:active_paths)
    end

    def request_for(uri, options = {})
      ActionDispatch::Request.new(env_for(uri).merge(options))
    end

    def env_for(*args)
      Rack::MockRequest.env_for(*args)
    end
  end
end
