require 'routing_filter/filter'

# TODO needs to unmemoize if any section is created, renamed, moved or deleted!

module RoutingFilter
  class SectionRoot < Filter
    extend ActiveSupport::Memoizable

    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    cattr_accessor :anchors_segments
    self.anchors_segments = { 'Page' => 'article' }

    def around_recognize(path, env, &block)
      if !excluded?(path)
        search, replace = *recognition(host(env))
        path.sub!(search) { "#{$1}#{replace}#{$2}" } if search
        path.chomp!('/')
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        remove_root_section!(path) unless excluded?(path)
      end
    end

    protected

      def excluded?(path)
        path =~ exclude
      end
      memoize :excluded?
      
      def recognition(host)
        site = Site.where(:host => host).first
        if site and root = site.sections.root
          anchor = anchors_segments[root.class.name] || raise("undefined url anchor segment for: #{root.class.name}")
          [%r(^(/[\w]{2})?(?:\/?)(/#{anchor}|\.|\?|/?\Z)), "/#{root.type.tableize}/#{root.id}"]
        end
      end
      memoize :recognition

      def remove_root_section!(path)
        path.sub!(%r(#{$2}/#{$3}/?), '') if path =~ generate_pattern && home?($3)
      end

      def generate_pattern
        @generate_pattern ||= %r(^(?:/[\w]{2})?(/(#{Section.types.map(&:tableize).join('|')})/([\d]+)(?:/|\.|\?|$)))
      end
      memoize :generate_pattern

      def home?(id)
        Section.find(id.to_i).try(:home?)
      end
      memoize :home?

      def host(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].compact.join(':')
      end
  end
end