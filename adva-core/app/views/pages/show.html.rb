class Pages::Show < Minimal::Template
  def to_html
    self << resource.article.body.html_safe
  end
end