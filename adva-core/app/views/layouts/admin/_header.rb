class Layouts::Admin::Header < Minimal::Template
  module Base
    def to_html
      render :partial => 'layouts/admin/top'

      div :id => 'header' do
        div :class => 'main' do
          main
        end
        div :class => 'right' do
          right
        end
      end
    end
    
    def main
      div :id => 'breadcrumbs' do
        # breadcrumbs
      end
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