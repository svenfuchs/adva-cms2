class Admin::Shared::Top < Minimal::Template
  def to_html
    div :id => 'top' do
      ul :class => 'menu left' do
        left
      end
      ul :class => 'menu right' do
        right
      end
    end
  end
  
  def left
    li { link_to(:'.sites', url_for([:admin, :sites])) }
    sections unless site.new_record?
  end
  
  def right
    li { link_to(:'.settings', url_for([:edit, :admin, site])) } unless site.new_record?
  end
  
  def sections
    li do
      link_to(:'.sections', url_for([:admin, site, :sections]))
      ul do
        site.sections.each do |section|
          li { link_to(section.title, url_for([:admin, site, section])) }
        end
      end
    end
  end
end