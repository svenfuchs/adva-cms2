module Adva
  module View
    class Form < Minimal::Template
      autoload :Sidebar, 'adva/view/form/sidebar'
      include Sidebar

      attr_reader :form

      def to_html
        form_tag
      end

      def form_tag
        simple_form_for(*form_arguments) do |form|
          @form = form
          fields
          button_group
        end
      end

      def form_arguments
        [resources]
      end

      def button_group
        content_tag(:div, :class => 'buttons') do
          buttons
        end
      end

      def buttons
        form.button :submit
      end

      def return_here
        hidden_field_tag :return_to, request.url
      end

      def pass_return_to
        hidden_field_tag :return_to, params[:return_to]
      end
    end
  end
end
