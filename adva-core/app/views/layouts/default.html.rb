class Layouts::Default < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag(:head) { head }
      content_tag :body, :class => body_class do
        div :id => 'header', :class => 'clearing' do
          h1 current_site.title
          # h2 current_site.subtitle
          login_links
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
    super(current_site.title)
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
  
  def login_links
    p :id => 'login_links', :class => 'navigation' do
      link_to :'.sign_in', new_user_session_path(:return_to => request.fullpath), :id => 'login_link'
      link_to :'.sign_up', new_user_registration_path, :id => 'signup_link'
    end
    p :id => 'logout_links', :class => 'navigation', :style => 'display: none;' do
      self << t(:'.logged_in_as', :user => '<span class="user_name"></span>')
      link_to :'.sign_out', destroy_user_session_path(:return_to => request.fullpath), :id => 'logout_link'
    end
  end
  
  def section_links
    ul :id => 'sections' do
      current_site.sections.each do |section|
        li link_to(section.title, section)
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