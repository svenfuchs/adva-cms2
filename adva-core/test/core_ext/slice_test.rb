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

    def unload(constant_name)
      ActiveSupport::Dependencies.autoloaded_constants.delete(constant_name.to_s)
      ActiveSupport::Dependencies.autoloaded_constants.delete(constant_name)
      ActiveSupport::Dependencies.loaded.delete_if {|path| path.ends_with?('/' + constant_name.to_s.underscore) }
      Object.send(:remove_const, constant_name) rescue nil
    end

    test 'needs an identifier' do
      assert_raise ArgumentError do
        Adva.slice 'articles_controller' do
        end
      end
      unload :ArticlesController
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
      unload :PagesController
    end

    test 'slice a controller' do
      can_slice 'articles_controller', 'ArticlesController'
      unload :ArticlesController
    end

    test 'slice a model' do
      can_slice 'article', 'Article'
      unload :Article
    end

    test 'slice a model that ends with "s" (singularization problem)' do
      class Address; end
      can_slice 'adva_core_tests/slice_test/address', 'AdvaCoreTests::SliceTest::Address'
    end

    test 'slice a minimal view' do
      can_slice 'layouts/admin', 'Layouts::Admin'
      unload :'Layouts::Admin'
    end

    test 'cannot slice nonexisting file' do
      assert_raise LoadError do
        Adva.slice 'humpty_dumpty#doo' do
        end
      end
    end

    test 'foreign NameErrors should be raised' do
      assert_raise NameError do
        Adva.slice 'articles_controller#missing_require' do
          include Adva::FeatureThatDoesNotExist
        end
      end
      unload :ArticlesController
    end
  end
end
