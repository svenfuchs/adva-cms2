module Adva
  class Cms < ::Rails::Engine
    initializer 'adva.cms.register_section_types' do
      require 'page'
    end
  end
end