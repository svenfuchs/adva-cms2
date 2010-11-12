module Adva
  module Engine
    module Slices
      def register_slice_paths
        ActiveSupport::Dependencies.slice_paths += slice_paths
      end

      def slice_paths
        ActiveSupport::Dependencies::SLICE_DIRS.map do |dir|
          path = self.paths.app.send(dir).to_a.first
          path if Dir["#{path}/**/*_slice*.rb"].present?
        end.compact
      end
    end
  end
end

require 'rails'

Rails::Application.class_eval do
  include Adva::Engine::Slices

  initializer "application.register_slice_paths" do |app|
    register_slice_paths
  end
end
