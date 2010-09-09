class Layouts::Admin < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag :head do
        head
      end
      content_tag :body do
        div do
          render :partial => 'layouts/admin/header'

          div :id => 'page' do
            div :class => 'main' do
              div :id => 'content' do
                content
              end
            end
            div :id => 'sidebar', :class => 'right' do
              sidebar
              self << 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
            end
          end
        end
      end
    end
  end

  def head
    self << tag(:meta, :'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
    self << title
    stylesheets
    javascripts
  end

  def doctype
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'.html_safe
  end

  def title
    super("adva-cms: Admin #{controller.controller_name}")
  end

  def stylesheets
    stylesheet_link_tag :admin, :media => 'all'
  end

  def javascripts
    javascript_include_tag :common, :admin
  end
  
  def content
    block.call
  end

  def sidebar
    block.call :sidebar
  end
end