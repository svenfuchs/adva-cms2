class Layouts::Base < Minimal::Template
  def to_html
    self << doctype
    html do
      content_tag :head do
        head
      end
      content_tag :body do
        body
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
    super(controller.controller_name) # TODO use i18n
  end

  def stylesheets
    stylesheet_link_tag :common, name
  end

  def javascripts
    javascript_include_tag :common, name
  end
  
  def header
  end
  
  def content
    block.call
  end

  def sidebar
    block.call :sidebar
  end
  
  def name
    @name ||= self.class.name.demodulize.underscore.to_sym
  end
end