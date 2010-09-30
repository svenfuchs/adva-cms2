Factory.define :asset do |f|
  f.file File.open(Adva::Assets.root.join('test/fixtures/rails.png'))
  f.description 'asset description'
end

Factory.define :image do |f|
  f.file File.open(Adva::Assets.root.join('test/fixtures/rails.png'))
  f.description 'image description'
end

Factory.define :video do |f|
  f.file File.open(Adva::Assets.root.join('test/fixtures/sample_video.swf'))
  f.description 'video description'
end