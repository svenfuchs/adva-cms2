require 'rails/engine'

module Adva  
  autoload :Engine, 'adva/engine'
  
  class << self
    def engines
      @engines ||= constants.map do |name| 
        constant = const_get(name)
        constant if constant < ::Rails::Engine
      end.compact
    end

    def engine_names
      @engine_names ||= engines.map { |constant| constant.name.split('::').last }
    end
  end
end