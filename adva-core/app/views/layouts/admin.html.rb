class Layouts::Admin < Layouts::Base
  def stylesheets
    stylesheet_link_tag :admin, :media => 'all'
  end

  def javascripts
    javascript_include_tag :common, :admin
  end
  
  def body
    div do
      header
      div :id => 'page' do
        div :class => 'main' do
          div :id => 'content' do
            content
          end
        end
        div :id => 'sidebar', :class => 'right' do
          sidebar
          self << 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
        end
      end
    end
  end

  def header
    render :partial => 'layouts/admin/header'
  end

  def sidebar
    block.call :sidebar
  end
end