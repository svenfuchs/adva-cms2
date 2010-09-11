class Admin::Blogs::Form < Minimal::Template
  def to_html
    simple_form_for(resources) do |section_form|
      section_form.hidden_field :type
      section_form.input :title
      section_form.button :submit
    end
  end
end