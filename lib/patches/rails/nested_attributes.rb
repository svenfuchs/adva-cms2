require 'gem/patching'

# Make build associations have their given type
# i.e.: site.sections.build(:type => 'Page').class == Page
# http://pragmatig.com/2010/06/04/fixing-rails-nested-attributes-on-collections-with-sti
Gem.patching('rails', '3.0.0.beta4') do 
  class ActiveRecord::Reflection::AssociationReflection
    def build_association(*options)
      if options.first.is_a?(Hash) and options.first[:type].presence
        options.first[:type].to_s.constantize.new(*options)
      else
        klass.new(*options)
      end
    end
  end
end