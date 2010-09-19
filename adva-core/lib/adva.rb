require 'rails/engine'

module Adva
  autoload :Engine,     'adva/engine'
  autoload :Generators, 'adva/generators'
  autoload :Registry,   'adva/registry'
  autoload :Responder,  'adva/responder'
  autoload :Testing,    'adva/testing'
  autoload :View,       'adva/view'

  mattr_accessor :out
  self.out = $stdout

  class << self
    def engines
      @engines ||= constants.map do |name|
        constant = const_get(name)
        constant if constant != Adva::Core && constant.is_a?(Class) && constant < ::Rails::Engine
      end.compact.sort { |lft, rgt| lft.name <=> rgt.name }.unshift(Adva::Core)
      @engines
    end

    def engine_names
      @engine_names ||= engines.map { |constant| constant.name.split('::').last }
    end
  end
end