class Admin::Sites::Index < Minimal::Template
  include do
    def to_html
    	table_for collection do |t|
    		t.column :site
    		t.column :actions, :class => :actions

    		t.row do |r, site|
    			r.cell link_to_site(site)
          r.cell links_to_actions([:view, :edit, :destroy], site)
    		end unless collection.empty?
    	end
    end

    def link_to_site(site)
      capture { link_to(site.name, url_for([:admin, site])) }
    end

    def link_to_view(site)
      capture { link_to(:'.actions.view', "http://#{site.host}", :class => :view) }
    end
  end
end

