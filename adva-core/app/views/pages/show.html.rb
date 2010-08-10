class Pages::Show < Minimal::Template
  def to_html
    h2 resource.article.title
    p resource.article.body
  end
end