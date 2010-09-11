class Admin::Posts::Form < Minimal::Template
  def to_html
    form_for(resources) do |f|
      f.label :title
      f.text_field :title
  
      f.label :body
      f.text_area :body
  
      f.submit resource.new_record? ? 'Create' : 'Save'
    end
  end
end