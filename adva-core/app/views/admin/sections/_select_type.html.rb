module Admin
  module Sections
    class SelectType < Minimal::Template
      def to_html
        h2 :'.title'

        form_for(resources, :as => :section, :url => { :action => :new }, :html => { :method => :get, :class => 'section_type' }) do |f|
          f.label :type

          section_types_for_select.each do |name, value|
            f.radio_button :type, value
            f.label "type_#{value.underscore}", name
          end

          f.submit 'Select'
        end
      end
    end
  end
end

