require_dependency 'layouts/default'

class Layouts::Blog < Layouts::Default
  include do
    def footer
      ul :class => :left do
        li :'.made_with'
      end
      ul :class => :right do
        li { link_to(:'.feed', '#', :class => :feed) }
      end
    end

    protected

      def name
        'default' # TODO
      end
  end
end
