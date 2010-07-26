require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Export < Thor::Group
      namespace 'adva:export'
      desc 'Export a static version of your site'
      
      def export
        require 'adva/exporter'
        Adva::Exporter.new('/tmp/export').export
      end
    end
  end
end

