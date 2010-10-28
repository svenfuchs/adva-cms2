require 'routing_filter'

module RoutingFilter
  class Categories < Filter
    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    def around_recognize(path, env, &block)
      unless excluded?(path)
        category_id = extract_category_id(env, path)
        yield.tap do |params|
          params[:category_id] = category_id if category_id
        end
      else
        yield
      end
    end

    def around_generate(params, &block)
      category_id = params.delete('category_id') || params.delete(:category_id)
      yield.tap do |path|
        insert_category_path(path, category_id) if !excluded?(path) && category_id
      end
    end

    protected

      def excluded?(path)
        path =~ exclude
      end
      # memoize :excluded?

      def extract_category_id(env, path)
        if section = section_for(env, path) and path =~ recognition_pattern(section)
          if category = section.categories.where(:path => $2).first
            path.gsub!("#{$1}#{$2}", '')
            path.replace('/') if path.blank?
            category.id.to_s
          end
        end
      end

      def recognition_pattern(section)
        paths = section.categories.map(&:path).reject(&:blank?)
        paths = paths.sort { |a, b| b.size <=> a.size }.join('|')
        paths.empty? ? %r(^$) : %r(^.*(/categories/)(#{paths})(?=/|\.|\?|$))
      end
      # memoize :recognition_pattern

      def insert_category_path(path, category_id)
        category = Category.find(category_id)
        if path =~ section_pattern
          path.sub!("/#{$1}/#{$2}", "/#{$1}/#{$2}/categories/#{category.path}")
        elsif category.section.root?
          path.sub!(%r(^/), "/categories/#{category.path}")
        end
      end

      def section_pattern
        types = Section.types.map { |type| type.downcase.pluralize }.join('|')
        %r(/(sections|#{types})/(\d+)(?=/|\.|\?|$))
      end
      # memoize :generate_pattern

      def section_for(env, path)
        if path =~ section_pattern
          Section.find($2)
        elsif path =~ %r(^/categories/\w+) && site = Site.by_host(host(env))
          site.sections.root
        end
      end

      def host(env)
        host, port = env.values_at('SERVER_NAME', 'SERVER_PORT')
        port == default_port ? host : [host, port].compact.join(':')
      end
  end
end

