require 'routing_filter/filter'

# If the path is, aside from a slash and an optional locale, the leftmost part
# of the path, replace it by "sections/:id" segments.

module RoutingFilter
  class SectionPath < Filter
    cattr_accessor :default_port
    self.default_port = '80'
    
    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    def around_recognize(path, env, &block)
      if !excluded?(path)
        site = find_site_by_host(env)
        segment = section_path(site, path)
        replace_section_path!(site, path, segment) if segment
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        remove_section_segments!(path) unless excluded?(path)
      end
    end
    
    protected
    
      def excluded?(path)
        path =~ exclude
      end
      
      def section_path(site, path)
        site and path =~ recognize_pattern(site) and $2
      end
      
      def replace_section_path!(site, path, segment)
        if section = section_by_path(site, segment)
          pattern = %r(^/([\w]{2,4}/)?(#{section.path})(?=/|\.|$))
          type    = section.type.pluralize.downcase
          path.sub!(pattern, "/#{$1}#{type}/#{section.id}#{$3}")
        end
      end
      
      def remove_section_segments!(path)
        if path =~ generate_pattern
          section = Section.find($2.to_i)
          path.sub!("/#{$1}/#{$2}", "#{section.path}#{$3}")
          path.replace("/#{path}") unless path[0, 1] == '/'
        end
      end

      def find_site_by_host(env)
        Site.where(:host => host_with_port(env)).first
      end
      
      def section_by_path(site, path)
        site.sections.where(:path => path).first
      end
    
      def section_paths(site)
        site ? site.sections.map(&:path).reject(&:blank?).sort { |a, b| b.size <=> a.size } : []
      end
      
      def recognize_pattern(site)
        paths = section_paths(site).join('|')
        %r(^/([\w]{2,4}/)?(#{paths})(?=/|\.|$))
      end
      
      def generate_pattern
        types = Section.types.map { |type| type.downcase.pluralize }.join('|')
        %r(/(sections|#{types})/([\d]+(/?))(\.?)) # ?(?=\b)?
      end

      def host_with_port(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].join(':')
      end
  end
end
