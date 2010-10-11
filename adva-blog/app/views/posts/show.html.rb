class Posts::Show < Minimal::Template
  include do
    def to_html
      div :class => resource.class.name.underscore do
        h2 { link_to(resource.title, resources, :class => 'entry-title', :rel => 'bookmark') }
        render :partial => 'posts/meta', :locals => { :post => resource }
        self << resource.body_html.html_safe
      end
    end
  end
end
