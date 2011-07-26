require 'gem-patching'

# Make build associations have their given type
# i.e.: site.sections.build(:type => 'Page').class == Page
# http://pragmatig.com/2010/06/04/fixing-rails-nested-attributes-on-collections-with-sti

Gem.patching('rails', '3.0.9') do
  class ActiveRecord::Reflection::AssociationReflection
    def build_association(*options, &block)
      if options.first.is_a?(Hash) && options.first[:type].present?
        options.first[:type].to_s.constantize.new(*options, &block)
      else
        super
      end
    end
  end
end
