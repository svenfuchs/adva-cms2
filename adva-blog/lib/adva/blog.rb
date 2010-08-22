require 'adva/engine'

require 'action_controller' # should be in truncate_html
require 'truncate_html'

module Adva
  class Blog < ::Rails::Engine
    include Adva::Engine

    initializer 'adva-blog.require_section_types', :after => 'prosecco.started' do
      config.to_prepare { require_dependency 'blog' }
    end
  end
end