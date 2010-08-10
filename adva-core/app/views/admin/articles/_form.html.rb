class Admin::Articles::Form < Minimal::Template
  def to_html
    simple_form_for(resources) do |article|
      article.input(:title)
      article.input(:body)
      article.button(:submit)
    end
  end
end