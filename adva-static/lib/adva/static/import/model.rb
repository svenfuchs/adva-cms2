module Adva
  class Static
    module Import
      module Model
        autoload :Base,    'adva/static/import/model/base'
        autoload :Blog,    'adva/static/import/model/blog'
        autoload :Page,    'adva/static/import/model/page'
        autoload :Post,    'adva/static/import/model/post'
        autoload :Section, 'adva/static/import/model/section'
        autoload :Site,    'adva/static/import/model/site'
      end
    end
  end
end