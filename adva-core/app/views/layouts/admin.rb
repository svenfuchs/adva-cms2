module Layouts
  class Admin < Layouts::Base
    include do
      def body
        div do
          header
          div :id => 'page' do
            div :id => 'main', :class => 'main' do
              render :partial => 'layouts/flash'
              div :id => 'content' do
                content
              end
            end
            div :id => 'sidebar', :class => 'right' do
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