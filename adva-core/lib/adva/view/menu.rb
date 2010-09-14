module Adva
  module View
    class Menu < Minimal::Template
      autoload :Admin, 'adva/view/menu/admin'

      def item(text, url = nil, options = {}, &block)
        li(:class => active?(url, options) ? "active" : nil) do
          options[:type] == :label ? h4(text, options) : link_to(text, url, options)
          self << capture { instance_eval(&block) } if block_given?
        end
      end

      def label(text, url = nil, options = {}, &block)
        item(text, url, options.merge(:type => :label), &block)
      end

      def link(text, url = '#', options = {}, &block)
        item(text, url, options.merge(:type => :link), &block)
      end

      protected

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
          @active_paths ||= path_and_parents(controller.request.path)
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