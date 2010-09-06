Before do
  Site.create!(
    :account => Account.create!,
    :name  => 'adva-cms',
    :host  => 'www.example.com',
    :title => "adva-cms",
    :sections_attributes => [{
      :type  => 'Page',
      :title => 'Home',
      :article_attributes => {
        :title => 'Heading',
        :body  => 'Body'
      }
    }]
  )
  User.create(
    :email    => 'admin@admin.org', 
    :password => 'admin'
  )
end

module GlobalsHelpers
  def current_site
    Site.first
  end

  def current_account
    Account.first
  end
end

World(GlobalsHelpers)