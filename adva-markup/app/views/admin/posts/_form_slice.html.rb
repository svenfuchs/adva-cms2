require_dependency 'admin/posts/_form.html.rb'

Admin::Posts::Form.include do
  def sidebar
    super
    tab :options do
      form.input :filter, :as => :select, :collection => Adva::Markup.options
    end
  end
end
