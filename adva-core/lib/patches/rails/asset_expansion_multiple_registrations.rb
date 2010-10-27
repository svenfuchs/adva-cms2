# Allow to register javascript/stylesheet_expansions to existing symbols
#
# see https://rails.lighthouseapp.com/projects/8994/tickets/1975-allow-to-register-javascriptstylesheet_expansions-to-existing-symbols

require 'action_view/helpers/asset_tag_helper'

module ActionView::Helpers::AssetTagHelper
  def self.register_javascript_expansion(expansions)
    expansions.each do |key, values|
      @@javascript_expansions[key] ||= []
      @@javascript_expansions[key] += Array(values)
    end
  end

  def self.register_stylesheet_expansion(expansions)
    expansions.each do |key, values|
      @@stylesheet_expansions[key] ||= []
      @@stylesheet_expansions[key] += Array(values)
    end
  end
end
