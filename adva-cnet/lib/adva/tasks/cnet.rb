require 'thor'
require 'thor/group'
require 'patches/thor/core_ext/hash'
require 'patches/thor/group/symbolized_options'

module Adva
  module Tasks
    class Cnet < Thor::Group
      namespace 'adva:cnet:fixtures:extract'
      desc 'Extract test fixture data from a directory containing cnet source files (e.g. full dump)'
      argument :source_dir
      
      def extract_fixtures
        Adva::Cnet::Origin::Fixtures.extract(source_dir)
      end
    end
  end
end

