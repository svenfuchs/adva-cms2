require 'routing_filter/filter'

module RoutingFilter
  class SectionRoot < Filter
    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    cattr_accessor :anchors_segments
    self.anchors_segments = { 'Page' => 'article' }

    def around_recognize(path, env, &block)
      if !excluded?(path) && root = find_root_section_by_host(env)
        prepend_root_section!(path, root)
        remove_trailing_slash!(path)
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

      def prepend_root_section!(path, root)
        path.sub!(recognize_pattern(root)) { "#{$1}/#{root.type.tableize}/#{root.id}#{$2}" }
      end

      def remove_trailing_slash!(path)
        path.chop! if path =~ %r(.+/\Z)
      end

      def remove_root_section!(path)
        path.sub!(%r(#{$2}/#{$3}/?), '') if path =~ generate_pattern && root?($3)
      end

      def recognize_pattern(root)
        anchor = anchors_segments[root.class.name] || raise("can not find url anchor segment for #{root.class}")
        %r(^(/[\w]{2})?(/#{anchor}|\.|\?|/?\Z))
      end

      def generate_pattern
        @generate_pattern ||= %r(^(?:/[\w]{2})?(/(#{Section.types.map(&:tableize).join('|')})/([\d]+)(?:/|\.|$)))
      end

      def find_root_section_by_host(env)
        site = Site.where(:host => host_with_port(env)).first
        site.sections.root if site
      end

      def root?(id)
        Section.find(id.to_i).try(:root?)
      end

      def host_with_port(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].join(':')
      end
  end
end