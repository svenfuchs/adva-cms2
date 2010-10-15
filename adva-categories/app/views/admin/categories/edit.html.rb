class Admin::Categories::Edit < Adva::View::Form
  include do
    def to_html
      h2 :'.title'
      render :partial => 'form'
    end
  end
end

