module Adva
  class Static
    class Import
      module Model
        class Site < Base
          delegate :host, :to => :'source.data'

          def update!
            record.account = Account.first || Account.create
            super
            sections.each { |section| section.update! }
          end

          def record
            @record ||= model.find_or_initialize_by_host(host)
          end

          def attribute_names
            @attribute_names ||= [:host, :name, :title] # :account,
          end

          def sections
            @sections ||= begin
              sections = source.sections.map { |section| Model.build(section, self) }
              sections << Page.new(source.path) if sections.empty?
              sections
            end
          end
        end
      end
    end
  end
end
