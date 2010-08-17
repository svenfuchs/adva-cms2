require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class SectionTest < Test::Unit::TestCase
    attr_reader :site

    def setup
      @site = Site.create(
        :name  => 'Site 1',
        :title => 'Site title',
        :host  => 'localhost:3000',
        :sections_attributes => [ { :type => 'Page', :title => 'Home' } ]
      )
    end

    def section
      @section ||= site.sections.create(:title => 'Section title')
    end

    test "section creation" do
      section = site.sections.create(:title => 'Section title')
      assert section.valid?
    end

    test "section validates presence of :title" do
      assert_equal ["can't be blank"], site.sections.create.errors[:title]
    end

    test "sections act as a nested set" do
      root = site.sections.first
      node_1 = site.sections.create(:title => 'node 1', :parent => root)
      node_2 = site.sections.create(:title => 'node 2', :parent => root)

      assert_equal [node_1, node_2], root.reload.children
      assert_equal root, site.sections.root
    end
  end
end