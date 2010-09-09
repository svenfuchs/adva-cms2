class Layouts::Admin < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag :head do
        head
      end
      content_tag :body do
        render :partial => 'layouts/admin/top'
        render :partial => 'layouts/admin/header'

        div :id => 'page' do
          # wrapping_main do |content|
          div :class => 'main' do
            render :partial => "admin/#{controller_name.gsub('_controller', '')}/menu"
            div :id => 'content' do
              content
            end
            div :id => 'sidebar', :class => 'right' do
              sidebar
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
  
  # def wrapping_main
  #   open, content, close = self.content
  #   self << open
  #   div(:class => 'main') { yield content }
  #   self << close
  # end
  # 
  # def content
  #   content = capture { block.call }
  #   if content =~ %r(^(<form[^>]+>))
  #     # TODO how to do this w/ just one regex? also, allow additional chars at the end
  #     [$1, content.gsub(%r(^<form[^>]+>|</form>$), ''), '</form>'.html_safe]
  #   else
  #     ['<div>'.html_safe, content, '</div>'.html_safe]
  #   end
  # end

  def sidebar
    block.call :sidebar
  end
end