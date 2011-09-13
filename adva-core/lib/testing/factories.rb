def Factory.the_account
  Account.first || Account.create!
end

Factory.define :site do |f|
  f.account { Factory.the_account }
  f.name    'adva-cms'
  f.host    'www.example.com'
  f.title   'adva-cms'
  f.sections_attributes [{
    :type => 'Page',
    :name => 'Home',
    :body => 'body'
  }]
end

Factory.define :section do |f|
  f.site { Site.first || Factory(:site) }
  f.name 'Home'
end

Factory.define :page do |f|
  f.site { Site.first || Factory(:site) }
  f.name 'Home'
end

Factory.define :content do |f|
  f.site { Site.first || Factory(:site) }
  f.section { Section.first || Factory(:section) }
  f.title 'Content'
end
