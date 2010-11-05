require File.expand_path('../test_helper', __FILE__)

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

  class I18nMissingTranslationsLogTest < Test::Unit::TestCase
    attr_reader :app, :log, :filename

    def setup
      @filename = '/tmp/adva-cms2-test/log/test_missing_translations.rb'
      FileUtils.mkdir_p(File.dirname(filename))
    end

    def teardown
      File.rm(filename) rescue nil
      I18n.missing_translations.clear
    end

    test 'logs to a memory hash' do
      log = I18n::MissingTranslationsLog.new
      log.log([:missing_translations, :foo])
      log.log([:missing_translations, :bar, :baz, :boz])
      log.log([:missing_translations, :bar, :baz, :buz])

      expected = { 'missing_translations' => { 'foo' => 'Foo', 'bar' => { 'baz' => { 'boz' => 'Boz', 'buz' => 'Buz' } } } }
      assert_equal expected, log
    end

    test 'dumps memory log as a yaml hash' do
      log = I18n::MissingTranslationsLog.new
      log.log([:missing_translations, :foo, :bar])
      log.dump(out = StringIO.new)

      expected = '---  missing_translations:    foo:      bar: Bar '
      assert_equal expected, out.string.gsub("\n", ' ')
    end

    test 'works as a rack middleware' do
      File.open(filename, 'w+') { |f| f.write(YAML.dump('en' => { 'foo' => 'Foo' })) }
      log = I18n::MissingTranslationsLog.new(lambda { |*| I18n.t(:missing) }, filename)
      log.call({})
      assert_equal({ 'en' => { 'foo' => 'Foo', 'missing' => 'Missing' }}, YAML.load_file(filename))
    end
  end
end

