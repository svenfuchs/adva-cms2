module Adva
  class Static
    class Import
      module Model
        class Section < Base
          attr_reader :parent

          def initialize(source, site = nil, parent = nil)
            super(source)
            @site = site
            @parent = parent
          end

          def record
            @record ||= model.find_or_initialize_by_slug(source.data.slug)
          end

          def attribute_names
            @attribute_names ||= [:site_id, :parent_id, :type, :name, :slug]
          end

          def type
            model_name
          end

          def site
            @site ||= Site.new(source.path.root)
          end

          def site_id
            site && site.record.persisted? ? site.record.id.to_s : nil
          end

          def parent
            @parent ||= source.path.root? || source.path.parent.root? ? nil : Section.new(source.path.parent)
          end

          def parent_id
            parent && parent.record.persisted? ? parent.record.id.to_s : nil
          end
        end
      end
    end
  end
end
