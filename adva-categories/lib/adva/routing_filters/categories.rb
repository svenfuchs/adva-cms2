require 'routing_filter/filter'

module RoutingFilter
  class Categories < Filter
    cattr_accessor :default_port
    self.default_port = '80'

    cattr_accessor :exclude
    self.exclude = %r(^/admin)

    def around_recognize(path, env, &block)
      unless excluded?(path)
        category_id = extract_category_id(path)
        yield.tap do |params|
          params[:category_id] = category_id if category_id
        end
      else
        yield
      end
    end

    def around_generate(params, &block)
      category_id = params.delete(:category_id)
      yield.tap do |path|
        insert_category_path(path, category_id) if !excluded?(path) && category_id
      end
    end

    protected

      def excluded?(path)
        path =~ exclude
      end
      # memoize :excluded?

      def extract_category_id(path)
        if section = section_by_path(path) and path =~ recognition_pattern(section)
          if category = section.categories.where(:path => $2).first
            path.gsub!("#{$1}#{$2}", '')
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
        if path =~ section_pattern
          category = Category.find(category_id)
          path.sub!("/#{$1}/#{$2}", "/#{$1}/#{$2}/categories/#{category.path}")
        end
      end

      def section_pattern
        types = Section.types.map { |type| type.downcase.pluralize }.join('|')
        %r(/(sections|#{types})/(\d+)(?=/|\.|\?|$))
      end
      # memoize :generate_pattern

      def section_by_path(path)
        Section.find($2) if path =~ section_pattern
      end

  end
end

