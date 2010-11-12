Factory.define :blog, :parent => :section, :class => Blog do |f|
  f.name 'Blog'
end

Factory.define :post do |f|
  f.section Blog.first
  f.title  'Title'
  f.body   'Body'
end
