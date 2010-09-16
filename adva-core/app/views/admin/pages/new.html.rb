class Admin::Pages::New < Adva::View::Form
  def to_html
    h2 :'.title'
    
    render 'admin/sections/select_type'

    simple_form_for(resources) do |f|
      f.hidden_field :type
      
      fieldset do
        f.input :title
        f.simple_fields_for(:article) do |a|
          a.input :body
        end
      end
    
      buttons do
        f.button :submit
      end
    end
  end
end