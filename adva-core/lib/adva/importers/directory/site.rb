require 'site'
require 'user'

module Adva
  module Importers
    class Directory
      class Site < Path
        include Loadable

        def import!
          clear!
          site.save!
          self
        end

        def clear!
          if record = ::Site.find_by_host(host)
            record.destroy
            record.account.try(:destroy)
          end
        end

        def loadable
          Path.new("#{self}/site.yml")
        end

        def site
          @site ||= ::Site.new(
            :account  => account,
            :sections => sections,
            :host     => host,
            :name     => name,
            :title    => title
          )
        end
        
        def account
          ::Account.new(:users => [::User.new(:email => 'admin@admin.org', :password => 'admin')])
        end
        
        def sections
          sections = Section.build(self).map(&:section)
          sections = [::Page.new(:title => 'Home', :article_attributes => { :title => 'Home' })] if sections.empty?
          sections
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
      end
    end
  end
end