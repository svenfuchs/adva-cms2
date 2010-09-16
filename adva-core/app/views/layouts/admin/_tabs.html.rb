class Layouts::Admin::Tabs < Minimal::Template
  def to_html
    div :class => :tabs do
      ul do
        tabs.each do |tab|
          li(:class => tab.active? ? :active : '') do
            link_to(:"admin.sidebar.tabs.#{tab.name}", "##{tab.name}")
          end
        end
      end
      # tabs.each do |tab|
      #   div :id => tab.name, :class => "tab #{tab.active? ? :active : ''}" do
      #     # div { tab.blocks.each { |block| block.call } }
      #   end
      # end
    end
  end
end