require 'routing_filter/filter'

module RoutingFilter
  class SectionRoot < Filter
    extend ActiveSupport::Memoizable

    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    cattr_accessor :anchors
    self.anchors = %w(article)

    def around_recognize(path, env, &block)
      # p "#{self.class.name}: #{path}"
      if !excluded?(path)
        search, replace = *recognition(host(env))
        path.sub!(search) { "#{$1}#{replace}#{$2}" } if search
      end
      yield
    end

    def around_generate(params, &block)
      yield.tap do |path|
        # p "#{self.class.name}: #{path}"
        remove_root_section!(path) unless excluded?(path)
      end
    end

    protected

      def excluded?(path)
        path =~ exclude
      end

      def recognition(host)
        if site = Site.by_host(host) and root = site.sections.root
          [%r(^(/[\w]{2})?(?:\/?)(#{anchors.join('|')}|\.|\?|/?\Z)), "/#{root.type.tableize}/#{root.id}"]
        end
      end

      def anchors
        @anchors ||= self.class.anchors.map { |anchor| "/#{anchor}" }
      end

      def remove_root_section!(path)
        path.sub!(%r(#{$2}/#{$3}/?), '') if path =~ generate_pattern && home?($3)
      end

      def generate_pattern
        @generate_pattern ||= %r(^(?:/[\w]{2})?(/(#{Section.types.map(&:tableize).join('|')})/([\d]+)(?:/|\.|\?|$)))
      end

      def home?(id)
        Section.find(id.to_i).try(:home?)
      end

      def host(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].compact.join(':')
      end
  end
end
