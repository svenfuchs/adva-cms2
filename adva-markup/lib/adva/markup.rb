require 'adva/core'
require 'RedCloth'
require 'rdiscount'

ERB::Util.send(:undef_method, :t) # wtf, redcloth!

module Adva
  class Markup < ::Rails::Engine
    include Adva::Engine

    autoload :ActionController, 'adva/markup/action_controller'
    autoload :ActiveRecord, 'adva/markup/active_record'

    mattr_accessor :filters
    self.filters = {
      :markdown => 'RDiscount',
      :textile  => 'RedCloth'
    }

    class << self
      def apply(name, markup)
        if filter = self.filter(name)
          filter.new(markup).to_html
        end
      end

      def filter(name)
        filters[name.to_sym].constantize if name.present? && filters[name.to_sym]
      end

      def keys
        @keys ||= filters.keys.map(&:to_s).sort
      end

      def names
        @names ||= keys.map { |key| key.titleize }
      end

      def options
        @options ||= Hash[*names.zip(keys).flatten]
      end
    end
  end
end

ActionController::Base.extend(Adva::Markup::ActionController::ActMacro)
ActiveRecord::Base.extend(Adva::Markup::ActiveRecord::ActMacro)

