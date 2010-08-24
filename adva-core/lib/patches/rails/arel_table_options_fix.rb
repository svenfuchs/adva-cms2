require 'gem_patching'

# Arel w/ Rails 3.0.0.rc2 breaks when #as is called on a table that was initialized w/
# an engine as second parameter
Gem.patching('rails', '3.0.0.rc2') do
  Arel::Table.class_eval do
    def initialize_with_options_fix(name, options = {})
      initialize_without_options_fix(name, options)
      @options ||= {}
    end
    alias_method_chain :initialize, :options_fix
  end
end