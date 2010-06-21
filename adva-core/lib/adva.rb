module Adva
  class << self
    def engines
      @engines ||= contants.select { |constant| constant < Rails::Engine }
    end
  end
end