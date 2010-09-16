class Admin::Sections::SelectType < Minimal::Template
  def to_html
    simple_form_for(resources, :as => :section, :url => { :action => :new }, :html => { :method => :get, :class => 'section_type' }) do |f|
      fieldset do
        f.label :type
        div :class => :radio_group do
          section_types_option_values.each do |name, value|
            f.radio_button :type, value
            f.label "type_#{value.underscore}", name, :class => :inline
          end
          f.submit 'Select', :class => :inline
        end
      end
    end
  end
end