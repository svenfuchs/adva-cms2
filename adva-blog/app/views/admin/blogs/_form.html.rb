class Admin::Blogs::Form < Adva::View::Form
  include do
    def fields
      form.hidden_field :type

      fieldset do
        column do
          form.input :title
        end

        column do
          form.input :slug
        end unless params[:action] == 'new'
      end
    end
  end
end