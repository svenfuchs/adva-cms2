class Admin::Posts::Index < Minimal::Template
  include do
    def to_html
    	table_for collection do |t|
    		t.column :post, :comments, :published, :author, :actions

    		t.row do |r, post|
    			r.cell link_to_post(post)
      		r.cell ''.html_safe # post.accept_comments? && post.comments.present? ? link_to(post.comments.size, admin_comments_path) : t(:"adva.common.none")
    			r.cell ''.html_safe # published_at_formatted(post)
    			r.cell link_to_author(post)
    			r.cell links_to_actions([:view, :edit, :destroy], post)
    		end

    		t.foot.row do |r|
          # r.cell will_paginate(@posts), :class => :pagination, :colspan => :all
    		end

    		t.empty :p, :class => 'posts list empty' do
          self.t(:'.empty', :link => capture { link_to(:'.create_item', new_path) }).html_safe
    		end
    	end
    end

    def link_to_post(post)
      status(post) + capture { link_to_edit(post.title, post) } # , :class => post.state
    end

    def link_to_author(post)
      ''.html_safe # link_to(post.author_name, admin_site_user_path(@site, post.author))
    end

    def link_to_view(post)
      capture { link_to(options[:text] || :'.view', public_url_for([blog, post]), :class => :view) }
    end

    def status(post)
      capture { span(t(:'.published'), :title => t(:'.published'), :class => 'status published') }
    end
  end
end

