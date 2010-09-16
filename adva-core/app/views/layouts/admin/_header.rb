class Layouts::Admin::Header < Minimal::Template
  module Base
    def to_html
      render :partial => 'layouts/admin/top'

      div :class => 'header' do
        div :class => 'main' do
        end
        div :class => 'right' do
          right
        end
      end
      
      div :class => 'header' do
        div :class => 'main' do
          menu
        end
        div :class => 'right' do
        end
      end
    end
    
    def breadcrumbs
      div :id => 'breadcrumbs' do
        # breadcrumbs
      end
    end
    
    def menu
      render :partial => "admin/#{controller_name.gsub('_controller', '')}/menu"
    end
    
    def right
      link_to_website
      # language_select
    end
  
    def link_to_website
      site = try(:site)
      link_to(t('.website'), public_url, :id => 'go_to_website') if site && site.persisted?
    end
  
    def language_select
      self << t('.change_language')
      select_tag :lang, options_for_select(I18n.available_locales.map { |l| l.to_s}, I18n.locale.to_s )
    end
  end
  include Base
end