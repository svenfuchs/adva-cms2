# Walks up the inheritance chain for given records if the generated named route
# helper does not exist. Caches resulting method names.
# see https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2986-polymorphic_url-should-handle-sti-better
Gem.patching('rails', '3.0.1') do
  require 'action_dispatch/routing/polymorphic_routes'

  ActionDispatch::Routing::PolymorphicRoutes.module_eval do
    def build_named_route_call(objects, inflection, options = {})
      objects = objects[:id] if objects.is_a?(Hash)
      NamedRouteCall.method_name(self, Array(objects), inflection, options)
    end

    class NamedRouteCall < Array
      mattr_accessor :cache
      self.cache = {}

      class << self
        def method_name(view, objects, inflection, options = {})
          key = cache_key(objects, inflection, options)
          method = cache[key] ||= begin
            NamedRouteCall.new(objects, inflection, options).detect do |method|
              view.respond_to?(method)
            end
          end
        end

        def cache_key(objects, inflection, options)
          objects = objects + [inflection, options[:action_prefix], options[:routing_type]]
          objects.map do |object|
            case object
            when String, Symbol
              object
            when Class
              object.name
            else
              "<#{object.class.name}>"
            end
          end
        end
      end

      attr_reader :objects, :inflection, :action_prefix, :routing_type

      def initialize(objects, inflection, options = {})
        @objects       = Array(objects)
        @inflection    = inflection
        @action_prefix = options[:action_prefix]
        @routing_type  = options[:routing_type] || :url
      end

      def detect
        while method = build
          return method if yield(method)
        end
        return first
      end

      def build
        if combination = combinations.shift
          self << method_name(combination)
          self.last
        end
      end

      def method_name(combination)
        combination[-1] = pluralize(combination.last)
        combination << 'index' if uncountable?(combination.last) && inflection == :plural
        combination.unshift(action_prefix).push(routing_type).compact.join('_')
      end

      def pluralize(string)
        # polymorphic_url passes an incorrect inflection in some cases
        if [String, Symbol].include?(objects.last.class)
          string
        elsif inflection == :singular
          string.singularize
        else
          string.pluralize
        end
      end

      def combinations
        @combinations ||= if classes.size == 1
          classes.first.map { |klass| [klass] }
        else
          classes.inject(classes.shift) { |a, b| a.product(b) }.map(&:flatten)
        end
      end

      def classes
        @classes ||= objects.map do |object|
          case object
          when Symbol, String
            [object.to_s]
          when Class
            ancestry(object)
          else
            ancestry(object.class)
          end
        end
      end

      def ancestry(model)
        ancestry = [model]
        ancestry << ancestry.last.superclass until ancestry.last.superclass == ActiveRecord::Base
        ancestry.map { |model| ActiveModel::Naming.plural(model).singularize }
      end

      def uncountable?(string)
        string.singularize == string.pluralize
      end
    end
  end
end

