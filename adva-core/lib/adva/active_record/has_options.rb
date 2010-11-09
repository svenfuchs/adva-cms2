module HasOptions
  def has_option(*names)
    unless respond_to?(:option_definitions)
      include InstanceMethods
      # FIXME [code slices] once lazy loaded code slices do work we should be able to make
      # this a class_inheritable_reader and remove the descendants loop. currently
      # class_inheritable_readers (which are used by :serialize, too) get out of
      # sync because has_option is being called from section_slice which is loaded
      # after Blog.
      cattr_accessor :option_definitions
      self.option_definitions ||= {}
      (descendants << self).each { |klass| klass.serialize :options }
    end

    definition = names.extract_options!
    names.map(&:to_sym).each do |name|
      self.option_definitions[name] = definition

      class_eval <<-rb, __FILE__, __LINE__
        def #{name}
          self.options ||= {}
          options.key?(:#{name}) ? options[:#{name}] : option_default(:#{name})
        end
        # alias #{name}_before_type_cast #{name}

        def #{name}=(value)
          options_will_change!
          self.options ||= {}
          options[:#{name}] = option_type_cast(:#{name}, value)
        end
      rb
    end
  end

  module InstanceMethods
    OPTION_DEFAULTS = { :default => nil, :type => :string }

    [:type, :default].each do |reader|
      define_method(:"option_#{reader}") do |name|
        self.class.option_definitions[name].key?(reader) ? self.class.option_definitions[name][reader] : OPTION_DEFAULTS[reader]
      end
    end

    define_method :option_type_cast do |name, value|
      return nil if value.nil?
      case option_type(name)
        when :string    then value.to_s
        when :integer   then value.to_i rescue value ? 1 : 0
        when :float     then value.to_f
        when :datetime  then ActiveRecord::ConnectionAdapters::Column.string_to_time(value)
        when :time      then ActiveRecord::ConnectionAdapters::Column.string_to_dummy_time(value)
        when :date      then ActiveRecord::ConnectionAdapters::Column.string_to_date(value)
        when :boolean   then ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
        else value
      end
    end
  end
end

ActiveRecord::Base.extend(HasOptions)
