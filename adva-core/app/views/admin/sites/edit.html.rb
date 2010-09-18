class Admin::Sites::Edit < Adva::View::Form
  def to_html
    h2 :'.title'
    super
  end

  def fields
    fieldset do
      column do
        form.input :name
        form.input :title
      end

      column do
        form.input :host
        form.input :subtitle
      end
    end
  end
end