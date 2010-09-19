Factory.define :image do |f|
  f.file File.open(Adva::Assets.root.join('test/fixtures/rails.png'))
  f.description 'description'
end