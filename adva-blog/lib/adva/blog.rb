require 'adva-core'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types' do
      config.to_prepare { require_dependency 'blog' }
    end
  end
end