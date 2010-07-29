require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Static < Thor::Group
      namespace 'adva:static'
      desc 'Static a static version of your site'
      class_option :target, :required => false
      
      def export
        require 'config/environment'
        Adva::Static::Exporter.new(Rails.application, symbolized_options).run
      end
    end
  end
end

