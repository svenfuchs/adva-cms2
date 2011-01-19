module GlobalHelpers
  
  def site
    Site.first || raise("Could not find a site. Maybe you want to set one up in your story background?")
  end

  def account
    Account.first || raise("Could not find a site. Maybe you want to set one up in your story background?")
  end
  
  def parsed_html
    # memoizing this causes problems since it seems to be memoized across requests
    # TODO: Figure out way to memoize within one request only
    # @parsed_body ||= Nokogiri::HTML(response.body)
    Nokogiri::HTML(response.body)
  end
  
end