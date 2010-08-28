require 'site'
require 'user'

module Adva
  module Importers
    class Directory
      module Models
        class Site < Base
          def attribute_names
            [:host, :name, :title, :account, :sections_attributes]
          end
        
          def loadable
            Path.new("#{source}/site.yml")
          end

          def record
            @record ||= ::Site.find_or_initialize_by_host(host)
          end

          def host
            @host ||= slug
          end

          def name
            @name ||= host
          end

          def title
            @title ||= name
          end
        
          def account
            ::Account.new(:users => [::User.new(:email => 'admin@admin.org', :password => 'admin')]) # TODO
          end
          
          def sections_attributes
            Section.build(source).map(&:attributes)
          end
        end
      end
    end
  end
end