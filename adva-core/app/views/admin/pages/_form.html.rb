class Admin::Pages::Form < Minimal::Template
  def to_html
    simple_form_for(resources) do |f|
      f.hidden_field :type
      f.input :title
      f.simple_fields_for(:article) do |a|
        a.input :title
        a.input :body
      end
      f.button :submit
    end
  end
end