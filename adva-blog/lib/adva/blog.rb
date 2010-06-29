require 'adva-core'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types' do
      require 'blog'
    end

    initializer 'adva-blog.add_blogs_to_site' do
      Site.has_many :blogs
    end
  end
end