require File.expand_path('../../test_helper', __FILE__)

require 'adva/generators/gemfile'

module AdvaCoreTests
  class GemfileTest < Test::Unit::TestCase
    attr_reader :source, :path

    def setup
      @source = File.expand_path('../../../../Gemfile', __FILE__)
      @path = '(adva-cms2|builds/\d+|adva-cms2/workspace|adva/cms2)'
    end

    test 'with_engines' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core])
      assert_match %r('adva-core'.*#{path}/adva-core'), gemfile.send(:with_engines)
      assert_no_match %r('adva-blog'.*#{path}/adva-blog'), gemfile.send(:with_engines)

      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core, :blog])
      assert_match %r('adva-core'.*#{path}/adva-core'), gemfile.send(:with_engines)
      assert_match %r('adva-blog'.*#{path}/adva-blog'), gemfile.send(:with_engines)
    end

    test 'engine_lines' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core])
      assert_match %r('adva-core'.*#{path}/adva-core'), gemfile.send(:engine_lines).first
    end

    test 'engines w/ [:blog] inserts :core' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:blog])
      assert_equal [:core, :blog], gemfile.send(:engines)
    end

    test 'engines w/ [:core]' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core])
      assert_equal [:core], gemfile.send(:engines)
    end

    test 'engines w/ [:all]' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:all])
      expected = [:core, :blog, :cache, :static, :user]
      assert_equal expected, gemfile.send(:engines) & expected
    end

    test 'engines w/ []' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [])
      expected = [:core, :blog, :cache, :static, :user]
      assert_equal expected, gemfile.send(:engines) & expected
    end

    test 'engines w/ nil' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => nil)
      expected = [:core, :blog, :cache, :static, :user]
      assert_equal expected, gemfile.send(:engines) & expected
    end
  end
end
