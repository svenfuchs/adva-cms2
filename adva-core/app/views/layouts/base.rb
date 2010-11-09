class Layouts::Base < Minimal::Template
  include do
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
      tag(:meta, :'http-equiv' => 'Content-Type', :content => 'text/html; charset=utf-8')
      tag(:meta, :'generator' => 'adva-cms2')
      title
      stylesheets
      javascripts
      block.call(:head)
    end

    def doctype
      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'.html_safe
    end

    def title(title = nil)
      super(title || default_title)
    end

    def stylesheets(*names)
      stylesheet_link_tag *[:common, name.to_sym].concat(names)
    end

    def javascripts(*names)
      javascript_include_tag *[:common, name.to_sym].concat(names)
    end

    def header
    end

    def body
    end

    def content
      block.call
    end

    def flash
      controller.flash.each do |name, value|
        div value, :id => "flash_#{name}", :class => "flash #{name}"
      end
    end

    def name
      @name ||= self.class.name.demodulize.underscore.to_sym
    end

    def default_title
      "#{controller.controller_name.titleize}: #{params[:action].titleize}"
    end
  end
end
