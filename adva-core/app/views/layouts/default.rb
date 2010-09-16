class Layouts::Default < Layouts::Base
  def title
    super(site.title)
  end

  def body
    div :id => :page do
      div :id => :header do
        h1 site.title
        h4 site.subtitle unless site.subtitle.blank?
        render :partial => 'layouts/default/menu'
      end
      div :id => :main do
        content
      end
    end
    div :id => :footer do
      footer
    end
  end
  
  def footer
    ul :class => :left do
      li :'.made_with'
    end
    ul :class => :right do
    end
  end
end