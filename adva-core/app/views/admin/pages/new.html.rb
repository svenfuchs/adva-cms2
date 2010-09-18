class Admin::Pages::New < Adva::View::Form
  include do
    def to_html
      h2 :'.title'
      render 'admin/sections/select_type'
      super
    end

    def fields
      fieldset do
        form.hidden_field :type
        form.input :name
        form.simple_fields_for(:article) do |a|
          a.input :body
        end
      end
    end
  end
end