require 'site'
require 'user'

module Adva
  class Static
    module Import
      class Directory
        module Models
          class Site < Base
            class << self
              def build(path)
                path.to_s =~ /^site.yml$/ ? [new(path)] : []
              end
            end

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
              sections = Section.build(source.paths)
              sections << Page.new(Path.new('home', source)) if sections.empty?
              sections.map(&:attributes)
            end
          end
        end
      end
    end
  end
end