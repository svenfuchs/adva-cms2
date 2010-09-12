require Adva::Core.root.join('lib/testing/skip_callbacks')

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
        :body  => 'Body'
      }
    }]
  )
  user = User.without_callbacks.create!(
    :email    => 'admin@admin.org', 
    :password => 'admin'
  )
  user.confirm!
end

module GlobalsHelpers
  def site
    Site.first
  end

  def account
    Account.first
  end
end

World(GlobalsHelpers)