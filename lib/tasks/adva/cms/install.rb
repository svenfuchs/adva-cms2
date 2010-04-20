require 'rails/generators'

module Adva
  class Cms
    class Install < Rails::Generators::Base
      def self.source_root
        @source_root ||= File.expand_path('../../../../..', __FILE__)
      end
      
      def copy_migrations
        Dir["#{self.class.source_root}/db/migrate/*"].each do |source|
          copy_file(source, source.gsub(self.class.source_root, '.'))
        end
      end
    end
  end
end