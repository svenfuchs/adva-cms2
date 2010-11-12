require 'active_support/dependencies'

module ActiveSupport
  module Dependencies
    def require_or_load_with_slices(*args)
      require_or_load_without_slices(*args).tap do |result|
        Slices.load(args.first) if result
      end
    end
    alias_method_chain :require_or_load, :slices
  end
end

module ActiveSupport
  module Slices
    mattr_accessor :slices
    self.slices = {}

    def paths
      Dependencies.autoload_paths
    end

    def load(filename)
      filename = local(filename)
      if slices.key?(filename)
        slices[filename].each { |slice| Dependencies.load(slice) }
      end
    end

    def register
      Dir["{#{paths.join(',')}}/**/*_slice*.rb"].each do |path|
        filename = local(path).sub('_slice', '')
        slices[filename] ||= []
        slices[filename] << path
      end
    end

    def local(path)
      path.sub(pattern, '')
    end

    def pattern
      @pattern ||= %r((#{paths.join('|')})/)
    end

    extend self
  end
end

Rails::Application.class_eval do
  initializer "application.register_slices" do |app|
    ActiveSupport::Slices.register
  end
end
