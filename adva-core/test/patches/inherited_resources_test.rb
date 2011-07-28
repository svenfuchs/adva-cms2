require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class InheritedResourcesTest < Test::Unit::TestCase

    class Fn0rdsController < InheritedResources::Base; end

    # To overload #collection with custom scopes or to further scope it in views
    test "it should return scope of end_of_association_chain in #collection" do
      controller = Fn0rdsController.new
      a_scope = "a scope result or arel"
      controller.stubs(:end_of_association_chain).returns(a_scope)
      assert_equal a_scope, controller.collection
    end

  end
end

