module Layouts
  class Admin < Layouts::Base
    include do
      def body
        div do
          header
          div :id => 'page' do
            div :id => 'main', :class => 'main' do
              div :id => 'content' do
                content
              end
            end
            div :id => 'sidebar', :class => 'right' do
              render :partial => 'layouts/admin/tabs', :locals => { :tabs => sidebar }
            end
          end
        end
      end

      def header
        render :partial => 'layouts/admin/header'
      end
    end
  end
end