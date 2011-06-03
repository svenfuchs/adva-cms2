require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class SliceTest < Test::Unit::TestCase
    def teardown
      Adva.loaded_slices.clear
    end

    def can_slice(path, class_name)
      Adva.slice "#{path}#foo" do
        def foo
          2 + 3
        end
      end
      object = class_name.constantize.new
      assert object.respond_to?(:foo), 'method not added'
      assert_equal 5, object.foo, 'method added incorrectly'
    end

    test 'needs an identifier' do
      assert_raise ArgumentError do
        Adva.slice 'articles_controller' do
        end
      end
      Object.send(:remove_const, :ArticlesController) rescue nil
    end

    test 'cannot apply the same slice twice' do
      3.times do
        Adva.slice 'pages_controller#stack' do
          include do
            def to_s
              super + '_stacked_'
            end
          end
        end
      end
      assert_equal 1, 'PagesController'.constantize.new.to_s.scan(/_stacked_/).count
      Object.send(:remove_const, :PagesController) rescue nil
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
        Adva.slice 'humpty_dumpty#doo' do
        end
      end
    end

  end
end
