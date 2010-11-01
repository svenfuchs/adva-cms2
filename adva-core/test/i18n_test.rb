require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class I18nTest < Test::Unit::TestCase
    include ActionView::Helpers

    def setup
      @_virtual_path = 'admin/sites/_menu'
    end

    def teardown
      I18n.backend.reload!
    end

    test 'the i18n backend cascades lookups' do
      I18n.backend.store_translations(:en, :edit => 'edit')
      assert_equal 'edit', I18n.t(:'admin.sites.menu.edit', :cascade => { :step => 1, :offset => 1, :skip_root => false })
    end

    test 'view helper: returns the :edit translation from the view path scope admin.sites.menu' do
      I18n.backend.store_translations(:en, :admin => { :sites => { :menu => { :edit => 'edit' } } })
      assert_equal 'edit', translate(:'.edit')
    end

    test 'view helper: returns the :edit translation from the view path scope admin.menu' do
      I18n.backend.store_translations(:en, :admin => { :menu => { :edit => 'edit' } })
      assert_equal 'edit', translate(:'.edit')
    end

    test 'view helper: returns the :edit translation from the view path scope admin' do
      I18n.backend.store_translations(:en, :menu => { :edit => 'edit' })
      assert_equal 'edit', translate(:'.edit')
    end

    # not yet supported in I18n::Cascade
    #
    # test 'view helper: returns the :edit translation from the root scope' do
    #   I18n.backend.store_translations(:en, :edit => 'edit')
    #   assert_equal 'edit', translate(:'.edit')
    # end
  end
end

