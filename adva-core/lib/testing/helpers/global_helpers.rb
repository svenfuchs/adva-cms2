module GlobalHelpers
  def site
    Site.first || raise("Could not find a site. Maybe you want to set one up in your story background?")
  end

  def account
    Account.first || raise("Could not find a site. Maybe you want to set one up in your story background?")
  end
end