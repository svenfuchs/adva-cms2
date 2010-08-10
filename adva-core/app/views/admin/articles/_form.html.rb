module Admin
  module Articles
    class Form < Minimal::Template
      include Minimal::Template::TranslatedTags
      def to_html
        simple_form_for(resources) do |article|
          article.input(:title)
          article.input(:body)
          article.button(:submit)
        end
      end
    end
  end
end