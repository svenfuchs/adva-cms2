module Adva
  module View
    class Menu < Minimal::Template
      autoload :Admin, 'adva/view/menu/admin'
      autoload :Items, 'adva/view/menu/items'

      def to_html
        build
        render_items
      end

      def item(text, url = nil, options = {}, &block)
        items.insert(text, url, options, block)
      end

      def label(text, url = nil, options = {}, &block)
        item(text, url, options.merge(:type => :label), &block)
      end

      protected
        def items
          @items ||= Items.new
        end

        def render_items
          items, @items = self.items, Items.new
          items.each { |args| render_item(*args) }
        end

        def render_item(text, url, options, block)
          options.merge!(:class => text.to_s.split('.').last) if text.is_a?(Symbol)
          url = url_for(url) unless url.is_a?(String) || options[:type] == :label

          li(:class => active?(url, options) ? 'active' : nil) do
            options[:type] == :label ? h4(text, options) : link_to(text, url, options)
            render_block(block) if block
          end
        end

        def render_block(block)
          self << capture do
            instance_eval(&block)
            render_items
          end
        end

        def name
          @name ||= self.class.name.demodulize.underscore
        end

        def css_classes
          ['menu', name].uniq
        end

        def active?(url, options)
          activate = options.key?(:activate) ? options.delete(:activate) : true
          delete   = options[:method] == :delete
          activate && !delete && active_paths.include?(url)
        end

        def active_paths
          @active_paths ||= path_and_parents(controller.request.fullpath)
        end

        def path_and_parents(path)
          path.split('/').inject([]) do |paths, segment|
            path = [paths.last == '/' ? '' : paths.last, segment].compact.join('/')
            paths << (path.empty? ? '/' : path)
          end
        end
    end
  end
end
