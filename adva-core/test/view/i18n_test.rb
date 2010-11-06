require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class I18nViewHelperTest < Test::Unit::TestCase
    attr_reader :view

    def setup
      @view = ActionView::Base.new
      view.instance_variable_set(:@_virtual_path, 'admin/sites/_menu')
    end

    def teardown
      I18n.backend.reload!
      I18n.missing_translations.delete('missing_translations')
    end

    test 'the i18n backend cascades lookups' do
      I18n.backend.store_translations(:en, :edit => 'edit')
      assert_equal 'edit', I18n.t(:'admin.sites.menu.edit', :cascade => { :step => 1, :offset => 1, :skip_root => false })
    end

    test 'view helper: returns the :edit translation from the view path scope admin.sites.menu' do
      I18n.backend.store_translations(:en, :admin => { :sites => { :menu => { :edit => 'edit' } } })
      assert_equal 'edit', view.translate(:'.edit')
    end

    test 'view helper: returns the :edit translation from the view path scope admin.menu' do
      I18n.backend.store_translations(:en, :admin => { :menu => { :edit => 'edit' } })
      assert_equal 'edit', view.translate(:'.edit')
    end

    test 'view helper: returns the :edit translation from the view path scope admin' do
      I18n.backend.store_translations(:en, :menu => { :edit => 'edit' })
      assert_equal 'edit', view.translate(:'.edit')
    end

    test 'logs missing translations' do
      I18n.t(:missing, :locale => :missing_translations)
      expected = { 'missing_translations' => { 'missing' => 'Missing' } }
      assert_equal expected, I18n.missing_translations
    end
  end
end

