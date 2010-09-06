module Adva
  module Views
    class Menu < Minimal::Template
      def item(text, url, options = {})
        li(:class => active?(url) ? "active" : nil) do
          link_to(text, url, options)
        end
      end
      
      protected

        def active?(url)
          active_paths.include?(url)
        end
  
        def active_paths
          @active_paths ||= paths_for(controller.request.path)
        end
  
        def paths_for(path)
          path.split('/').inject([]) do |paths, segment|
            path = [paths.last == '/' ? '' : paths.last, segment].compact.join('/')
            paths << (path.empty? ? '/' : path)
          end
        end
    end
  end
end