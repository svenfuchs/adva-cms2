require 'adva/engine'
require 'active_record' # should be in simple_slugs
require 'simple_slugs'  # hmm, need to require this here so client app class reloading doesn't crash

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types', :after => 'prosecco.started' do
      config.to_prepare { require_dependency 'blog' }
    end
  end
end