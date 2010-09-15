module Adva
  module Engine
    module SlicedModels

      # TODO while preloading seems to work fine, it slows the dev mode down
      # quite a bit. should be replace with an approace which lazyloads sliced
      # models in Dependencies maybe an after-load hook in Dependencies would
      # work.
      def preload_sliced_models
        types = %w(controllers models views)
        paths = types.map { |type| self.paths.app.send(type).to_a.first }
        pattern = %r((?:#{paths.join('|')})/((?:\w+/)*\w+_slice(?:.\w+)*).rb$)

        Dir["{#{paths.join(',')}}/**/*.rb"].each do |filename|
          # const_name = filename =~ %r(/([^/]*)_slice.rb) && $1.camelize
          # ActiveSupport::Dependencies.mark_for_unload(const_name)
          # ActiveSupport::Dependencies.autoloaded_constants << const_name
          # ActiveSupport::Dependencies.autoloaded_constants.uniq!
          # require_dependency(const_name.underscore)
          if filename =~ pattern
            require $1.gsub(%r(_slice), '')
            load(filename)
          end
        end
      end
    end
  end
end

require 'rails'

Rails::Application.class_eval do
  include Adva::Engine::SlicedModels

  initializer "application.preload_sliced_models" do |app|
    config.to_prepare { app.preload_sliced_models }
  end
end