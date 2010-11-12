# walks up the inheritance chain for given records if the generated named route
# helper does not exist
# see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2986-polymorphic_url-should-handle-sti-better
Gem.patching('rails', '3.0.1') do
  require 'action_dispatch/routing/polymorphic_routes'

  ActionDispatch::Routing::PolymorphicRoutes.module_eval do
    def build_named_route_call_with_sti_fallbacks(records, inflection, options = {})
      if records.is_a?(Array)
        combinations = class_name_combinations_for_named_route_call(records)
        methods = []
        combinations.each do |combination|
          records = apply_class_name_combination_to(combination, records)
          methods << build_named_route_call_without_sti_fallbacks(records.dup, inflection, options)
          return methods.last if respond_to?(methods.last)
        end
        methods.first
      else
        build_named_route_call_without_sti_fallbacks(records, inflection, options)
      end
    end
    alias_method_chain :build_named_route_call, :sti_fallbacks

    def apply_class_name_combination_to(combination, records)
      records.map do |record|
        target = combination.shift
        record.respond_to?(:becomes) ? record.becomes(target.constantize) : record
      end
    end

    def class_name_combinations_for_named_route_call(objects)
      names = classes_for_named_route_call(objects)
      names.inject(names.shift) { |lft, rgt| lft.product(rgt) }.map(&:flatten)
    end

    def classes_for_named_route_call(objects)
      objects.map do |object|
        case object
        when Symbol, String
          [object]
        when Class
          ancestry_for_named_route_call(object)
        else
          ancestry_for_named_route_call(object.class)
        end
      end
    end

    def ancestry_for_named_route_call(model)
      [model].tap do |ancestry|
        until ancestry.last.superclass == ActiveRecord::Base
          ancestry << ancestry.last.superclass
        end
      end.map(&:name)
    end

    # class NamedRouteCall
    #   attr_reader :records, :inflection, :options

    #   def initialize(view, records, inflection, options = {})
    #     records = [extract_record(records)] unless records.is_a?(Array)
    #     @view, @records, @inflection, @options = view, records, inflection, options
    #   end

    #   def build
    #     segments.unshift(action_prefix).push(routing_type).join('_')
    #   end

    #   def segments
    #     last = segment_plurals.pop
    #     segment_plurals.map(&:singularize).tap do |route|
    #       route << inflection == singluar ? last.singularize : last
    #       route << 'index' if ActiveModel::Naming.uncountable?(record) && inflection == :plural
    #     end
    #   end

    #   def segment_plurals
    #     records.map do |record|
    #       if record.is_a?(Symbol) || record.is_a?(String)
    #         record
    #       else
    #         ActiveModel::Naming.plural(record)
    #       end
    #     end
    #   end

    #   def build
    #     unless records.is_a?(Array)
    #       record = extract_record(records)
    #       route  = []
    #     else
    #       record = records.pop
    #       route = records.map do |parent|
    #         if parent.is_a?(Symbol) || parent.is_a?(String)
    #           parent
    #         else
    #           ActiveModel::Naming.plural(parent).singularize
    #         end
    #       end
    #     end

    #     if record.is_a?(Symbol) || record.is_a?(String)
    #       route << record
    #     else
    #       route << ActiveModel::Naming.plural(record)
    #       route = [route.join("_").singularize] if inflection == :singular
    #       route << "index" if ActiveModel::Naming.uncountable?(record) && inflection == :plural
    #     end

    #     route << routing_type(options)

    #     action_prefix(options) + route.join("_")
    #   end

    #   def extract_record(record_or_hash_or_array)
    #     case record_or_hash_or_array
    #       when Array; record_or_hash_or_array.last
    #       when Hash;  record_or_hash_or_array[:id]
    #       else        record_or_hash_or_array
    #     end
    #   end

    #   def action_prefix
    #     options[:action] ? options[:action] : ''
    #   end

    #   def routing_type
    #     options[:routing_type] || :url
    #   end
    # end
  end

  # ActionDispatch::Routing::PolymorphicRoutes.module_eval do
  #   def build_named_route_call_with_sti_fallbacks(records, inflection, options = {})
  #     # FIXME [polymorphic url_for] should cache successful transformation for reuse
  #     # currently only works if records is an array (also might be a single record or a Hash)
  #     original_records = records
  #     records = records.dup unless records.is_a?(Symbol)
  #     method = build_named_route_call_without_sti_fallbacks(records, inflection, options)
  #     if !respond_to?(method, true) && original_records.is_a?(Array) && records = walk_sti_for_named_route_call(original_records.dup)
  #       build_named_route_call_with_sti_fallbacks(records, inflection, options)
  #     else
  #       method
  #     end
  #   end
  #   alias_method_chain :build_named_route_call, :sti_fallbacks

  #   def walk_sti_for_named_route_call(records)
  #     walked = []
  #     while record = records.pop
  #       if record.is_a?(ActiveRecord::Base) && record.class.superclass != ActiveRecord::Base
  #         return records + [record.becomes(record.class.superclass)] + walked
  #       end
  #       walked << record
  #     end
  #     nil
  #   end
  # end
end

