module Admin
  module Pages
    class New < Minimal::Template
      def to_html
        render 'admin/sections/select_type'
        h2 t(:'.title')
        render 'form'
      end
    end
  end
end