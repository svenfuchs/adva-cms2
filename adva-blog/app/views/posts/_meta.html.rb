class Posts::Meta < Minimal::Template
  include do
    def to_html
      div :class => :meta do
        self << t(:'.info_html', :date => published_at, :author => nil)
      end
    end

    def published_at
      capture { content_tag(:abbr, l(post.created_at, :format => :post), :title => post.created_at, :class => 'updated') }
    end
  end
end
