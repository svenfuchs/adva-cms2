create_file 'Gemfile', "load '#{config[:gem_root]}/Gemfile'"
remove_file 'public/index.html'