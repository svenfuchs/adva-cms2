gem_root = config[:gem_root]
gemfile = File.read("#{gem_root}/Gemfile")
gemfile = gemfile.gsub('../', '').gsub('__FILE__', "'#{gem_root}'")

create_file 'Gemfile', gemfile
remove_file 'public/index.html'

