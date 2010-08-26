require 'core_ext/ruby/array/flatten_once'

module Adva
  module Importers
    class Directory
      module Models
        autoload :Base,    'adva/importers/directory/models/base'
        autoload :Blog,    'adva/importers/directory/models/blog'
        autoload :Page,    'adva/importers/directory/models/page'
        autoload :Post,    'adva/importers/directory/models/post'
        autoload :Section, 'adva/importers/directory/models/section'
        autoload :Site,    'adva/importers/directory/models/site'
      end
    end
  end
end