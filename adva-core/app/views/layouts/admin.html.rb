class Layouts::Admin < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag :head do
        head
      end
      content_tag :body do
        render :partial => 'layouts/admin/header'

        div :id => 'page' do
          # self << yield(:form) if @content_for_form
          div :class => 'main' do
            div :id => 'content' do
              content
            end
            div :id => 'sidebar' do
              sidebar
            end
          end
          # self<< '</form>'.html_safe if @content_for_form
        end
      end
    end
  end

  def head
    tag :meta, :'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8'
    title
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