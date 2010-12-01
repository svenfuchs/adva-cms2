# http://mislav.uniqpath.com/2010/09/cuking-it-right/

# Then I should see "foo" in the top menu
scopes = {
  'the title' => 'h1, h2, h3',
  'the top menu' => '#top',
  'the action menu' => '#actions',
  'the sidebar' => '#sidebar'
}
scopes.each do |context, selector|
  Then /^(.+) (?:with)?in #{context}$/ do |step|
    within(selector) do
      Then step
    end
  end
end
