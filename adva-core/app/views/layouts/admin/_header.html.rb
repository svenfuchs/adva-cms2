class Layouts::Admin::Header < Minimal::Template
  def to_html
    render :partial => 'layouts/admin/top'

    div :id => 'header' do
      div :class => 'main' do
        div :id => 'breadcrumbs' do
          # breadcrumbs
        end
        render :partial => "admin/#{controller_name.gsub('_controller', '')}/menu"
      end
      div :class => 'right' do
        # login_status
        link_to_website
        # language_select
      end
    end
  end
        
  def login_status
    if current_user
      link_to t('.sign_out', :user => current_user.email), destroy_user_session_path
    else
      link_to t('.sign_in'), new_user_session_path
    end
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