class Pages::Show < Minimal::Template
  include do
    def to_html
      self << resource.article.body.html_safe
    end
  end
end