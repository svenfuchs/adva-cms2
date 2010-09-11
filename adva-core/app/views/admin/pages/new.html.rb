class Admin::Pages::New < Minimal::Template
  def to_html
    render 'admin/sections/select_type'
    h2 :'.title'
    simple_form_for(resources) do |f|
      f.hidden_field :type
      f.input :title
      f.simple_fields_for(:article) do |a|
        a.input :body
      end
      buttons do
        f.button :submit
      end
    end
  end
end