module Admin
  module Pages
    class Edit < Minimal::Template
      def to_html
        h2 t(:'.title')
        render 'form'
        p button_to("Delete", resources, :method => :delete)
      end
    end
  end
end