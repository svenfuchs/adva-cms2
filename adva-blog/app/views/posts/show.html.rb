class Posts::Show < Minimal::Template
  def to_html
    div :class => resource.class.name.underscore do
      h2 resource.title
      render :partial => 'posts/meta', :locals => { :post => resource }
      self << resource.body.html_safe
    end
  end
end