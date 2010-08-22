require 'site'
require 'user'

module Adva
  module Importers
    class Directory
      class Site < Model
        def initialize(*args)
          @attribute_names = [:account, :sections, :host, :name, :title]
          super
        end
        
        def import!
          clear!
          site.save!
          self
        end

        def clear!
          Account.all.each(&:destroy)
        end

        def loadable
          Path.new("#{self}/site.yml")
        end
        
        def account
          ::Account.new(:users => [::User.new(:email => 'admin@admin.org', :password => 'admin')])
        end

        def site
          @site ||= ::Site.find_or_initialize_by_host(host).tap do |site| 
            site.attributes = attributes
          end
        end
        
        def sections
          @sections ||= Section.build(self).map(&:section).tap do |sections|
            sections << ::Page.new(:title => 'Home', :article_attributes => { :title => 'Home' }) if sections.empty?
          end
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