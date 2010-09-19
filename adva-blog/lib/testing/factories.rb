Factory.define :blog do |f|
  f.name 'Blog'
end

Factory.define :post do |f|
  f.section Blog.first
  f.title  'Title'
  f.body   'Body'
end