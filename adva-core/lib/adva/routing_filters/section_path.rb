require 'routing_filter/filter'

# If the path is, aside from a slash and an optional locale, the leftmost part
# of the path, replace it by "sections/:id" segments.

# TODO needs to unmemoize if any section is created, renamed, moved or deleted!

module RoutingFilter
  class SectionPath < Filter
    extend ActiveSupport::Memoizable

    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    def around_recognize(path, env, &block)
      if !excluded?(path)
        search, replace = recognition(host(env), path)
        path.sub!(%r(^/([\w]{2,4}/)?(#{search})(?=/|\.|\?|$)), "/#{$1}#{replace}#{$3}") if search
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        if !excluded?(path)
          search, replace = *generation(path)
          path.sub!(search) { "#{replace}#{$3}" } if search
          path.replace("/#{path}") unless path[0, 1] == '/'
        end
      end
    end

    protected

      def excluded?(path)
        path =~ exclude
      end
      # memoize :excluded?

      def recognition(host, path)
        site = site_by_host(host)
        if site and path =~ recognition_pattern(host)
          section = site.sections.where(:path => $2).first
          [$2, "#{$1}#{section.type.pluralize.downcase}/#{section.id}"]
        end
      end
      
      def recognition_pattern(host)
        site = site_by_host(host)
        paths = site.sections.map(&:path).reject(&:blank?)
        paths = paths.sort { |a, b| b.size <=> a.size }.join('|')
        paths.empty? ? %r(^$) : %r(^/([\w]{2,4}/)?(#{paths})(?=/|\.|\?|$))
      end
      # memoize :recognition_pattern

      def generation(path)
        if path =~ generate_pattern
          section = Section.find($2.to_i)
          ["/#{$1}/#{$2}", "#{section.path}#{$3}"]
        end
      end

      def generate_pattern
        types = Section.types.map { |type| type.downcase.pluralize }.join('|')
        %r(/(sections|#{types})/([\d]+(/?))(\.?))
      end
      # memoize :generate_pattern

      def host(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].compact.join(':')
      end
      
      def site_by_host(host)
        Site.where(:host => host).first
      end
  end
end
