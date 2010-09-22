copy_file config[:source].join('lib/bundler/repository.rb'), "#{app_path}/lib/bundler/repository.rb"
copy_file config[:source].join('Gemfile'), "#{app_path}/Gemfile"
remove_file 'public/index.html'