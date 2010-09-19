Factory.define :site do |f|
  f.account(Account.first || Account.create!)
  f.name  'adva-cms'
  f.host  'www.example.com'
  f.title 'adva-cms'
  f.sections_attributes [{
    :type => 'Page',
    :name => 'Home',
    :article_attributes => {
      :body => 'Body'
    }
  }]
end

Factory.define :page do |f|
  f.name 'Home'
end

Factory.define :blog do |f|
  f.name 'Blog'
end

Factory.define :post do |f|
  f.section Blog.first
  f.title  'Title'
  f.body   'Body'
end

Factory.define :admin, :class => User do |f|
  f.email 'admin@admin.org'
  f.password 'admin'
  f.after_create { |user| user.confirm! }
end

Factory.define :image do |f|
  f.file File.open(Adva::Assets.root.join('test/fixtures/rails.png'))
  f.description 'description'
end