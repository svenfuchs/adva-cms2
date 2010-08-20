class Pages::Show < Minimal::Template
  def to_html
    h2 resource.article.title
    self << resource.article.body.html_safe
  end
end