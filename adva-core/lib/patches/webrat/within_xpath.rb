# see https://webrat.lighthouseapp.com/projects/10503/tickets/153-within-should-support-xpath

Gem.patching('webrat', '0.7.2') do
  Webrat::Scope.class_eval do
    def scoped_dom
      if @selector =~ /^\.?\/\/?/
        @scope.dom.xpath(@selector).first
      else
        @scope.dom.css(@selector).first
      end
    end
  end
end if defined?(Webrat)
