class Admin::Posts::Form < Minimal::Template
  def to_html
    form_for(resources) do |f|
      fieldset do
        f.label :title
        f.text_field :title
  
        f.label :body
        f.text_area :body
      end
      buttons do
        f.submit resource.new_record? ? 'Create' : 'Save' # TODO
      end
    end
  end
end