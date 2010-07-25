Module.class_eval do
  def option_reader(*names)
    options = names.last.is_a?(Hash) ? names.last : {}
    names.each do |name|
      define_method(name) { @options[name.to_sym] }
      define_method(:"#{name}?") { !!@options[name.to_sym] }
    end
  end
end