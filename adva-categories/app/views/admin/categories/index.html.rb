class Admin::Categories::Index < Minimal::Template
  include do
    def to_html
    	table_for blog.categories do |t|
    		t.column :category, :actions

    		t.row do |r, category|
    			r.cell link_to_edit(category.name, category)
    			r.cell links_to_actions([:edit, :destroy], category)
    		end

    		t.empty :p, :class => 'categories list empty' do
          self.t(:'.empty', :link => capture { link_to(:'.create_item', new_path(:category)) }).html_safe
    		end
    	end
    end
  end
end

