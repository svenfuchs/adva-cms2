module Layouts
  class Admin < Layouts::Base
    include do
      def head
        csrf_meta_tag
        super
      end

      def body
        div do
          header
          page
        end
      end

      def header
        render :partial => 'layouts/admin/header'
      end

      def stylesheets
        stylesheet_link_tag :admin
      end

      def javascripts
        javascript_include_tag :admin
      end

      def page
        div :id => 'page' do
          main
          sidebar
        end
      end

      def main
        div :id => 'main', :class => 'main' do
          flash
          content
        end
      end

      def content
        div :id => 'content' do
          super
        end
      end

      def sidebar
        div :id => 'sidebar', :class => 'right' do
          block.call :sidebar
        end
      end
     end
  end
end
