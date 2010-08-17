class Admin::Articles::Form < Minimal::Template
  def to_html
    simple_form_for(resources) do |f|
      f.input(:title)
      f.input(:body)
      f.button(:submit)
    end
  end
end