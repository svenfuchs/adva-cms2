require File.expand_path('../test_helper', __FILE__)

require 'patches/rails/sti_associations'

module AdvaCore
  class PatchesTest < Test::Unit::TestCase
    test "make accepts_nested_attributes use sti" do
      assert_equal Page, Site.new.sections.build(:type => 'Page').class
    end
  end
end