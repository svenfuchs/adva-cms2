require 'adva-core'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types' do
      config.to_prepare { require_dependency 'blog' }
    end

    initializer 'adva-blog.add_blogs_to_site' do
      config.to_prepare { Site.has_many :blogs }
    end
  end
end