require 'rails/engine'

module Adva
  autoload :Engine,     'adva/engine'
  autoload :Generators, 'adva/generators'
  autoload :Rack,       'adva/rack'
  autoload :Registry,   'adva/registry'
  autoload :Responder,  'adva/responder'
  autoload :Tasks,      'adva/tasks/core'
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
    end

    def engine(name)
      name = "Adva::#{name.camelize}" unless name.to_s.starts_with?('Adva::')
      engines.detect { |engine| engine.name == name }
    end

    def engine_names
      @engine_names ||= engines.map { |constant| constant.name.split('::').last.underscore.to_sym }
    end

    def engine?(name)
      engine_names.include?(name)
    end
    alias :installed? :engine?

    # Helps you slice and dice your addons to adva-cms
    #
    # load and slice (patch) the class +Existing::Stuff+
    # in 'ur/engine/existing/stuff_slice.rb' 
    # Adva.slice 'existing/stuff' do
    #   include do
    #     def fn0rd
    #       23 + 42
    #     end
    #   end
    #   attr_accessor :things
    # end
    def slice(path, &block)
      raise ArgumentError, 'must give block to slice and dice' unless block_given?
      require_dependency(path)
      class_name = path.classify
      class_name.constantize.class_eval(&block)
    end
  end
end


