class User::Sessions::New < Minimal::Template
  def to_html
    h2 :'.title'

    simple_form_for(resource, :as => resource_name, :url => session_path(resource_name)) do |f|
      hidden_field_tag :return_to, params[:return_to]

      f.input :email
      f.input :password

      if devise_mapping.rememberable?
        div :class => :checkbox_group do
          f.check_box :remember_me
          f.label :remember_me, :class => :inline
        end
      end

      buttons do
        f.submit t(:'.submit')
        render :partial => 'user/links'
      end
    end
  end
end