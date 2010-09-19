Factory.define :page do |s|
  s.name 'Page'
end

Factory.define :blog do |s|
  s.name 'Blog'
end

Factory.define :post do |s|
  s.section Blog.first
  s.title  'Title'
  s.body   'Body'
end