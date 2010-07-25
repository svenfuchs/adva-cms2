require 'adva/engine'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types', :after => 'prosecco.started' do
      config.to_prepare { require_dependency 'blog' }
    end
  end
end