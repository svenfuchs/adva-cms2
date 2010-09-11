class Posts::Meta < Minimal::Template
  def to_html
    div :class => :meta do
      self << t(:'.info', :date => date, :author => nil).html_safe # TODO 
    end
  end
  
  def date
    capture do
      content_tag(:abbr, :title => post.created_at, :class => 'updated') do
        self << l(post.created_at, :format => :post)
      end
    end
  end
end