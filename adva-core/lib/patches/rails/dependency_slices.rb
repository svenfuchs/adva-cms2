require 'active_support/dependencies'

module ActiveSupport::Dependencies
  SLICE_DIRS = %w(helpers controllers models views)

  mattr_accessor :slice_paths
  self.slice_paths = []

  def require_or_load_with_slices(file_name, const_path = nil)
    require_or_load_without_slices(file_name, const_path).tap do |result|
      load_slices(file_name) if result
    end
  end
  alias_method_chain :require_or_load, :slices

  def load_slices(file_name)
    if file_name = slice_path(file_name)
      slice_paths.each do |path|
        path = "#{path}/#{file_name}"
        # puts "load slice: #{path}" if File.file?(path)
        load(path) if File.file?(path)
      end
    end
  end

  def slice_path(path)
    pattern = %r(.*(?:#{SLICE_DIRS.join('|')})/)
    path.sub('.', '_slice.') if path = path.sub(pattern, '')
  end
end
