require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class SectionTest < Test::Unit::TestCase
    attr_reader :site

    def setup
      @site = Site.create(
        :name  => 'Site 1',
        :title => 'Site title',
        :host  => 'localhost:3000',
        :sections_attributes => [ { :type => 'Page', :name => 'Home' } ]
      )
    end

    def section
      @section ||= site.sections.create(:name => 'Section name')
    end

    test "section creation" do
      section = site.sections.create(:name => 'Section name')
      assert section.valid?
    end

    test "section validates presence of :name" do
      assert_equal ["can't be blank"], site.sections.create.errors[:name]
    end

    test "sections act as a nested set" do
      root = site.sections.first
      node_1 = site.sections.create!(:name => 'node 1', :parent_id => root.id)
      node_2 = site.sections.create!(:name => 'node 2', :parent_id => node_1.id)

      [node_1, node_2].map(&:reload)

      assert_equal root, site.sections.root
      assert_equal [node_1], root.reload.children
      assert_equal [node_2], node_1.reload.children

      assert_equal [1, 6], [root.lft, root.rgt]
      assert_equal [2, 5], [node_1.lft, node_1.rgt]
      assert_equal [3, 4], [node_2.lft, node_2.rgt]
    end

    test "a section has its path denormalized (happens in simple_nested_set) and strips the home section path off (on read)" do
      root_1 = site.sections.first
      node_1 = site.sections.create!(:name => 'node 1', :parent => root_1)
      node_2 = site.sections.create!(:name => 'node 2', :parent => node_1)

      root_2 = site.sections.create!(:name => 'root 2')
      node_3 = site.sections.create!(:name => 'node 3', :parent => root_2)
      node_4 = site.sections.create!(:name => 'node 4', :parent => node_3)

      assert_equal 'home',                 root_1.reload.read_attribute(:path)
      assert_equal 'home/node-1',          node_1.reload.read_attribute(:path)
      assert_equal 'home/node-1/node-2',   node_2.reload.read_attribute(:path)

      assert_equal 'root-2',               root_2.reload.read_attribute(:path)
      assert_equal 'root-2/node-3',        node_3.reload.read_attribute(:path)
      assert_equal 'root-2/node-3/node-4', node_4.reload.read_attribute(:path)
    end

    # test "Section.paths returns all paths w/ home section path stripped off" do
    #   root_1 = site.sections.first
    #   node_1 = site.sections.create!(:name => 'node 1', :parent => root_1)
    #   node_2 = site.sections.create!(:name => 'node 2', :parent => node_1)
    #
    #   root_2 = site.sections.create!(:name => 'root 2')
    #   node_3 = site.sections.create!(:name => 'node 3', :parent => root_2)
    #   node_4 = site.sections.create!(:name => 'node 4', :parent => node_3)
    #
    #   paths = ['', 'node-1', 'node-1/node-2', 'root-2', 'root-2/node-3', 'root-2/node-3/node-4']
    #   assert_equal paths, site.sections.paths
    # end
  end
end