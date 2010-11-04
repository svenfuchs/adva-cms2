class Layouts::Default < Layouts::Base
  include do
    def title
      super(site.title)
    end

    def body
      page
      footer
    end

    def page
      div :id => :page do
        header
        div :id => :main do
          content
        end
        sidebar
      end
    end

    def header
      div :id => :header do
        h1 site.title
        h4 site.subtitle unless site.subtitle.blank?
        render :partial => 'layouts/default/menu'
      end
    end

    def footer
      div :id => :footer do
        ul :class => :left do
          li :'.made_with'
        end
        ul :class => :right do
        end
      end
    end

    def sidebar
      sidebar = capture { block.call(:sidebar) }
      div sidebar, :id => 'sidebar', :class => 'left' unless sidebar.blank?
    end
  end
end
