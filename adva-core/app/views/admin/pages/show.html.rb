class Admin::Pages::Show < Adva::View::Form
  include do
    def to_html
      h2 :'.title'
      super
    end

    def fields
      form.simple_fields_for(:article) do |a|
        a.input :body
      end
    end
  
    def buttons
      form.button :submit
    end

    def sidebar
      tab :options do
        form.input :title
        form.input :slug
      end
    end
  end
end