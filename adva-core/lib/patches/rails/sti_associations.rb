require 'gem-patching'

# Make build associations have their given type
# i.e.: site.sections.build(:type => 'Page').class == Page
# http://pragmatig.com/2010/06/04/fixing-rails-nested-attributes-on-collections-with-sti

Gem.patching('rails', '3.0.15') do
  class ActiveRecord::Reflection::AssociationReflection
    def build_association(*options, &block)
      if options.first.is_a?(Hash) && options.first[:type].present?
        requested_class = options.first[:type].to_s.constantize
        if requested_class <= klass
          requested_class.new(*options, &block)
        else
          # do not allow to create random record, for example User with role admin
          raise "cannot build associated record: #{requested_class} does not inherit from #{klass}"
        end
      else
        klass.new(*options,&block)
      end
    end
  end
end
