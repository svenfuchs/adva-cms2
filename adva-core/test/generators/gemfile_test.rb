require File.expand_path('../../test_helper', __FILE__)

require 'adva/generators/gemfile'

module AdvaCoreTests
  class GemfileTest < Test::Unit::TestCase
    attr_reader :source

    def setup
      @source = File.expand_path('../../../../Gemfile', __FILE__)
    end

    test 'with_engines' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core])
      assert_match %r('adva-core'.*(adva-cms2|builds/\d+)/adva-core'), gemfile.send(:with_engines)
      assert_no_match %r('adva-blog'.*(adva-cms2|builds/\d+)/adva-blog'), gemfile.send(:with_engines)

      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core, :blog])
      assert_match %r('adva-core'.*(adva-cms2|builds/\d+)/adva-core'), gemfile.send(:with_engines)
      assert_match %r('adva-blog'.*(adva-cms2|builds/\d+)/adva-blog'), gemfile.send(:with_engines)
    end

    test 'engine_lines' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [:core])
      assert_match %r('adva-core'.*(adva-cms2|builds/\d+)/adva-core'), gemfile.send(:engine_lines).first
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
      assert_equal [:core, :assets, :blog, :cache, :static, :user], gemfile.send(:engines)
    end

    test 'engines w/ []' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => [])
      assert_equal [:core, :assets, :blog, :cache, :static, :user], gemfile.send(:engines)
    end

    test 'engines w/ nil' do
      gemfile = Adva::Generators::Gemfile.new('/tmp', :source => source, :engines => nil)
      assert_equal [:core, :assets, :blog, :cache, :static, :user], gemfile.send(:engines)
    end
  end
end
