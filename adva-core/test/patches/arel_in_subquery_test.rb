require File.expand_path('../../test_helper', __FILE__)

module AdvaCoreTests
  class ArelInSubqueryTest < Test::Unit::TestCase
    def setup
      super
      Section.delete_all
      Factory(:section, :name => 'foo')
      Factory(:section, :name => 'bar')
    end

    test "in accepts a select manager (query object)" do
      sections = Section.arel_table
      query = sections.project(:name).where(sections[:name].in(sections.project(:name).where(sections[:name].eq('foo'))))
      sql = %(SELECT name FROM "sections" WHERE "sections"."name" IN (SELECT name FROM "sections" WHERE "sections"."name" = 'foo'))

      assert_equal sql, query.to_sql
      assert_equal ['foo'], Section.connection.select_values(query.to_sql)
    end

    test "not_in accepts a select manager (query object)" do
      sections = Section.arel_table
      query = sections.project(:name).where(sections[:name].not_in(sections.project(:name).where(sections[:name].eq('foo'))))
      sql = %(SELECT name FROM "sections" WHERE "sections"."name" NOT IN (SELECT name FROM "sections" WHERE "sections"."name" = 'foo'))

      assert_equal sql, query.to_sql
      assert_equal ['bar'], Section.connection.select_values(query.to_sql) & %w(foo bar)
    end
  end
end

