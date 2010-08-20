require File.expand_path('../../test_helper', __FILE__)

require 'adva/routing_filters/section_path'
require 'page'

module AdvaCoreTests
  class SectionPathTest < Test::Unit::TestCase
    attr_reader :filter, :site, :home, :docs, :api

    def setup
      @site   = Site.create!(:name => 'site', :title => 'site', :host => 'www.example.com', :sections_attributes => [{ :title => 'home' }])
      @home   = site.sections.first
      @docs   = site.sections.create!(:title => 'docs')
      @api    = site.sections.create!(:title => 'api', :parent => docs)
      @filter = RoutingFilter::SectionPath.new
      
      [home, docs, api].map(&:reload)
      site.sections.reset
    end

    test "section_path? matches the path of an existing section" do
      assert '/docs', filter.send(:section_path, site, '/docs')
      assert '/docs/api', filter.send(:section_path, site, '/docs/api')
    end

    test "section_path? does not match the path of the root section" do
      assert !filter.send(:section_path, site, '/home')
    end
    
    test "replace_section_path! replaces the path of an existing section" do
      path = '/docs'
      filter.send(:replace_section_path!, site, path, 'docs')
      assert_equal "/sections/#{docs.id}", path
    end
    
    test "remove_section_segments! replaces a section url segment with the section's path" do
      path = "/sections/#{docs.id}"
      filter.send(:remove_section_segments!, path)
      assert_equal '/docs', path
    end
  end
end