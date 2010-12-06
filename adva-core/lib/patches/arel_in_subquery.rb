# https://gist.github.com/730257
# bars.where(bars[:id].in(foos.project(:bar_id).where(...)))

Gem.patching('arel', '2.0.6') do
  Arel::Predications.module_eval do
    def in_with_select_fix(other)
      case other
      when Arel::SelectManager
        Arel::Nodes::In.new(self, other)
      else
        in_without_select_fix(other)
      end
    end
    alias_method_chain :in, :select_fix

    def not_in_with_select_fix(other)
      case other
      when Arel::SelectManager
        Arel::Nodes::NotIn.new(self, other)
      else
        in_without_select_fix(other)
      end
    end
    alias_method_chain :not_in, :select_fix
  end

  Arel::Visitors::ToSql.class_eval do
    def visit_Arel_SelectManager o
      o.to_sql
    end

    def visit_Arel_Nodes_In o
      "#{visit o.left} IN (#{visit o.right})"
    end

    def visit_Arel_Nodes_NotIn o
      "#{visit o.left} NOT IN (#{visit o.right})"
    end

    def visit_Array o
      o.empty? ? 'NULL' : o.map { |x| visit x }.join(', ')
    end
  end
end
