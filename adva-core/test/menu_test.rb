require File.expand_path('../test_helper', __FILE__)

require 'adva/view/menu'

module AdvaCoreTests
  class MenuTest < Test::Unit::TestCase
    include TestHelper::Application
    include TestHelper::MinimalTemplate

    class Menu < Adva::View::Menu
      def main
        item(:foo, '/foo')
        label(:bar) { self << 'BAR' }
      end
    end

    attr_reader :controller, :menu

    def setup
      @controller = Admin::PostsController.new
      @controller.request = request_for('/admin/sites/1/blogs/1/posts/new')

      @menu = Menu.new(view)
      @menu.locals = { :controller => @controller }

      super
    end

    def render
      menu.send(:render_items)
      menu.output_buffer
    end

    test 'registers items' do
      menu.main
      assert_equal 2, menu.send(:items).size
    end

    test 'renders items' do
      menu.main
      assert_equal '<li><a href="/foo" class="foo">foo</a>', render.split("\n").first
    end

    test 'renders items with blocks' do
      menu.main
      assert_match %r(BAR), render
    end

    test 'inserts an item before an existing one' do
      menu.main
      menu.item(:baz, '/baz', :before => :bar)
      assert_match /foo.*baz.*bar/m, render
    end

    test 'inserts an item after an existing one' do
      menu.main
      menu.item(:baz, '/baz', :after => :foo)
      assert_match /foo.*baz.*bar/m, render
    end

    test 'replaces an existing one' do
      menu.main
      menu.item(:baz, '/baz', :replace => :bar)
      assert !render.include?('BAR')
    end

    test 'item uses the last part of a i18n key starting with a dot as a css class of the generated link' do
      menu.item(:'.bar', 'http://example.com')
      assert_match /<a[^>]*class="bar"[^>]*>/, render
    end

    test 'item uses the last part of a dot separated i18n key as a css class of the generated link' do
      menu.item(:'foo.bar', 'http://example.com')
      assert_match /<a[^>]*class="bar"[^>]*>/, render
    end

    test 'label uses the last part of a dot separated i18n key as a css class of the h4 tag' do
      menu.label(:'foo.bar')
      assert_match /<h4[^>]*class="bar"[^>]*>/, render
    end

    test 'active_paths' do
      expected = %w(/ /admin /admin/sites /admin/sites/1 /admin/sites/1/blogs /admin/sites/1/blogs/1 /admin/sites/1/blogs/1/posts /admin/sites/1/blogs/1/posts/new)
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
