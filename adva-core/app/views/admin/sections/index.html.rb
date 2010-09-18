class Admin::Sections::Index < Minimal::Template
  include do
    def to_html
    	table_for collection, :collection_name => :sections, :class => 'sections list tree' do |t|
    		t.column :section
    		t.column :actions, :class => :actions

    		t.row(:class => 'section') do |r, section|
    			r.add_class "level_#{section.level}"
    			r.cell link_to_section(section)
    			r.cell link_to_edit(section) + 
    			       link_to_delete(section)
    		end
    	end
    end
  
    def link_to_section(section)
      status(section) + capture { link_to(section.title, url_for([:admin, site, section])) } # :class => section.state
    end
  
    def link_to_edit(section)
      capture { link_to(:'.edit', url_for([:edit, :admin, site, section]), :class => :edit) }
    end
  
    def link_to_delete(section)
      capture { link_to(:'.delete', url_for([:admin, site, section]), :class => :delete, :method => :delete) }
    end
  
    def status(section)
      capture { span(t(:'.published'), :title => t(:'.published'), :class => 'status published') }
    end
  end
end