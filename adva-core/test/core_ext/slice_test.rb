require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class SliceTest < Test::Unit::TestCase
    def can_slice(path, class_name)
      Adva.slice path do
        def foo
          2 + 3
        end
      end
      object = class_name.constantize.new
      assert object.respond_to?(:foo), 'method not added'
      assert_equal 5, object.foo, 'method added incorrectly'
    end

    test 'slice a controller' do
      can_slice 'articles_controller', 'ArticlesController'
      Object.send(:remove_const, :ArticlesController) rescue nil
    end

    test 'slice a model' do
      can_slice 'article', 'Article'
      Object.send(:remove_const, :Article) rescue nil
    end

    test 'slice a minimal view' do
      can_slice 'layouts/admin', 'Layouts::Admin'
      Layouts.send(:remove_const, :Admin) rescue nil
    end

    test 'cannot slice nonexisting file' do
      assert_raise LoadError do
        Adva.slice 'humpty_dumpty' do
        end
      end
    end

  end
end
