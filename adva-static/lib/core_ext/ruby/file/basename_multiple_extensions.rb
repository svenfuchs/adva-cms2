File.class_eval do
  class << self
    def basename_with_multiple_extensions(path, extensions = nil)
      if extensions.is_a?(Array)
        path = basename_without_multiple_extensions(path)
        extensions = extensions.map { |extension| Regexp.escape(extension) }
        path.sub(/(#{extensions.join('|')})$/, '')
      else
        basename_without_multiple_extensions(*[path, extensions].compact)
      end
    end
    alias :basename_without_multiple_extensions :basename
    alias :basename :basename_with_multiple_extensions
  end
end