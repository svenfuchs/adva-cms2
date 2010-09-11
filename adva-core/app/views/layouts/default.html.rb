class Layouts::Default < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag(:head) { head }
      content_tag :body, :class => body_class do
        div :id => 'header', :class => 'clearing' do
          h1 site.title
          # h2 site.subtitle
          section_links
          # self << Menus::Sections.new.build(self).root.render(:id => 'sections')
          # yield :header
        end
        div :id => 'page' do
          div :id => 'main' do
            #= render :partial => 'shared/flash'
            yield
          end
          # yield(:footer) || render(:partial => 'shared/footer')
        end
        # yield :foot
      end
    end
  end

  def head
    self << tag(:meta, :'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
    self << tag(:meta, :'generator' => 'adva-cms2')
    # self << meta_tags(@article) if @article
    self << title
    self << stylesheets
    self << javascripts
    # self << authorize_elements
    # self << block.call :head
  end

  def doctype
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'.html_safe
  end

  def title
    super(site.title)
  end

  def stylesheets
    stylesheet_link_tag :default
  end

  def javascripts
    javascript_include_tag :common, :default
  end
  
  def body_class
    resource.class.name.singularize.underscore if resource
  end
  
  def section_links
    ul :id => 'sections' do
      site.sections.each do |section|
        li { link_to(section.title, section) }
      end
    end
  end
  
  def content
    block.call
  end

  def sidebar
    block.call :sidebar
  end
end