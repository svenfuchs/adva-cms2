require 'gem-patching'

# add "blog edit_blog" as css classes. should propose a patch to simple_form

Gem.patching('simple_form', '1.2.2') do
  SimpleForm::ActionViewExtensions::FormHelper.module_eval do
    [:form_for, :fields_for, :remote_form_for].each do |helper|
      class_eval <<-METHOD, __FILE__, __LINE__
        def simple_#{helper}(record_or_name_or_array, *args, &block)
          css_classes = simple_css_classes(record_or_name_or_array)

          options = args.extract_options!
          options[:builder] = SimpleForm::FormBuilder
          options[:html] ||= {}
          options[:html][:class] = "simple_form \#{css_classes} \#{options[:html][:class]}".strip

          with_custom_field_error_proc do
            #{helper}(record_or_name_or_array, *(args << options), &block)
          end
        end
      METHOD
    
      def simple_css_classes(record_or_name_or_array)
        css_classes = case record_or_name_or_array
          when String, Symbol
            record_or_name_or_array.to_s
          when Array
            record = record_or_name_or_array.last
            action = record.new_record? ? 'new' : 'edit'
            [dom_class(record), dom_class(record, action)].join(' ')
          else 
            dom_class(record_or_name_or_array)
        end
      end
    end
  end
end