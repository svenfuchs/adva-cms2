class Posts::Meta < Minimal::Template
  include do
    def to_html
      div :class => :meta do
        self << t(:'.info_html', :date => published_at, :author => nil)
      end
    end

    def published_at
      capture { content_tag(:abbr, l(post.published_at, :format => :post), :title => post.published_at, :class => 'updated') }
    end
  end
end
