require 'thor/group'

Thor::Group.class_eval do
  protected
    def symbolized_options
      options.to_hash.symbolize_keys
    end
end
