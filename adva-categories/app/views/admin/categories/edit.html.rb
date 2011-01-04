class Admin::Categories::Edit < Adva::View::Form
  include do
    def to_html
      h2 t(:'.title', :category_name => resource.name)
      render :partial => 'form'
    end
  end
end

