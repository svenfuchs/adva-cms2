module Admin
  module Pages
    class Form < Minimal::Template
      def to_html
        simple_form_for(resources) do |section_form|
          section_form.hidden_field :type
          section_form.input :title
          section_form.simple_fields_for(:article) do |article_form|
            article_form.input :title
            article_form.input :body
          end
          section_form.button :submit
        end
      end
    end
  end
end