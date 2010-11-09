require 'gem_patching'

# remove trailing segments '.1' and  query params '?=1' from url
Gem.patching('rails', '3.0.1') do
  ActionDispatch::Routing::RouteSet.class_eval do
    def url_for_with_singleton_resource_patch(options)
      url_for_without_singleton_resource_patch(options).
        sub(/\.\d+(\Z|\?)/) { $1 || '' }.
        sub(/\?=\d+$/, '')
    end
    alias_method_chain :url_for, :singleton_resource_patch
  end
end

# walks up the inheritance chain for given records if the generated named route
# helper does not exist
# see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2986-polymorphic_url-should-handle-sti-better
Gem.patching('rails', '3.0.1') do
  require 'action_dispatch/routing/polymorphic_routes'

  ActionDispatch::Routing::PolymorphicRoutes.module_eval do
    def build_named_route_call_with_sti_fallbacks(records, inflection, options = {})
      # FIXME [polymorphic url_for] should cache successful transformation for reuse
      # currently only works if records is an array (also might be a single record or a Hash)
      original_records = records
      records = records.dup unless records.is_a?(Symbol)
      method = build_named_route_call_without_sti_fallbacks(records, inflection, options)
      if !respond_to?(method, true) && original_records.is_a?(Array) && records = walk_sti_for_named_route_call(original_records.dup)
        build_named_route_call_with_sti_fallbacks(records, inflection, options)
      else
        method
      end
    end
    alias_method_chain :build_named_route_call, :sti_fallbacks

    def walk_sti_for_named_route_call(records)
      walked = []
      while record = records.pop
        if record.is_a?(ActiveRecord::Base) && record.class.superclass != ActiveRecord::Base
          return records + [record.becomes(record.class.superclass)] + walked
        end
        walked << record
      end
      nil
    end
  end
end

# ActionDispatch::Integration::Runner defines method_missing but no accompaning
# respond_to? method. It thus doesn't respond_to? to named route url helpers even
# though it actually responds to them. Happens with the PolymorphicRoutes patch
# above, so this patch is here as well.
Gem.patching('rails', '3.0.1') do
  ActionDispatch::Integration::Runner.module_eval do
    def respond_to?(method, include_private = false)
      @integration_session.respond_to?(method, include_private) || super
    end
  end
end

