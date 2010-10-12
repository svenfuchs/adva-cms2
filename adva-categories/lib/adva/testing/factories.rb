Factory(:category) do |f|
  f.section Section.first || Factory(:section)
  f.name 'Category'
end
