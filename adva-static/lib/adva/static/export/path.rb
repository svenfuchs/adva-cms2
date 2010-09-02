require 'uri'

module Adva
  class Static
    class Export
      class Path < String
        attr_reader :host

        def initialize(path)
          @host = URI.parse(path.to_s).host rescue 'invalid.host'
          path  = normalize_path(path)
          super
        end

        def filename
          @filename ||= normalize_filename(self)
        end

        def extname
          @extname ||= File.extname(self)
        end

        def html?
          extname.blank? || extname == '.html'
        end

        def remote?
          host.present?
        end

        protected

          def normalize_path(path)
            path = URI.parse(path.to_s).path rescue '/'               # extract path
            path = path[0..-2] if path[-1, 1] == '/'                  # remove trailing slash
            path = "/#{path}" unless path[0, 1] == '/'                # add leading slash
            path
          end

          def normalize_filename(path)
            path = path[1..-1] if path[0, 1] == '/'                   # remove leading slash
            path = 'index' if path.empty?                             # use 'index' instead of empty paths
            path = (html? ? "#{path.gsub(extname, '')}.html" : path)  # add .html extension if necessary
            path
          end
      end
    end
  end
end