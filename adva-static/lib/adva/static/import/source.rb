module Adva
  class Static
    class Import
      module Source
        autoload :Base,    'adva/static/import/source/base'
        autoload :Blog,    'adva/static/import/source/blog'
        autoload :Path,    'adva/static/import/source/path'
        autoload :Page,    'adva/static/import/source/page'
        autoload :Post,    'adva/static/import/source/post'
        autoload :Section, 'adva/static/import/source/section'
        autoload :Site,    'adva/static/import/source/site'

        TYPES = [Site] + Section::TYPES

        class << self
          def build(type, path)
            const_get(type).new(path)
          end

          def recognize(paths)
            [Site, Post, Section].map { |type| type.recognize(paths) }.flatten.compact.sort
          end
        end
      end
    end
  end
end
