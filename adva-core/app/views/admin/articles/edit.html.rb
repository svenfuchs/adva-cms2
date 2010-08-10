module Admin
  module Articles
    class Edit < Minimal::Template
      def to_html
        link_to "Settings", resources.unshift(:edit)[0..-2] # TODO
        h2 t(:'.title')
        render 'form'
      end
    end
  end
end