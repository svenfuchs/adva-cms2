copy_file config[:adva_core].join('lib/bundler/repository.rb'), "#{app_path}/lib/bundler/repository.rb"
copy_file config[:adva_core].join('lib/adva/generators/templates/app/Gemfile'), "#{app_path}/Gemfile"
copy_file config[:adva_core].join('lib/adva/generators/templates/app/Thorfile'), "#{app_path}/Thorfile"
remove_file 'public/index.html'
