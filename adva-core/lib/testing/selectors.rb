module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when /the page/
      "html > body"

    when /([a-z ]+) form/
      name = $1.gsub(' ', '_') #.gsub(/edit_/, '')
      "form.#{name}, form##{name}"

      #  I follow "View" within the "Blog" row
      #                         ^^^^^^^^^^^^^^
      #  selects the rows in which the given text shows up
    when /the "([^"]*)" row/
      having_text = %Q~contains( text(), "#{$1}")~
      row = "//table//tr[ descendant::*[#{having_text}] ]"
      [:xpath, row]

      #  I should see "Categories" within tabs
      #                                   ^^^^
    when /^((?:a?n )?[a-z]+)$/
      ".#{$1}"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /the (notice|error|info) flash/
    #    ".flash.#{$1}"
    
    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /"(.+)"/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
