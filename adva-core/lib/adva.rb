module Adva  
  autoload :Engine, 'adva/engine'
  
  class << self
    def engines
      @engines ||= contants.select { |constant| constant < Rails::Engine }
    end
  end
end