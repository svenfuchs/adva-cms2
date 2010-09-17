Adva::Generators::Gemfile.new("#{app_path}/Gemfile", config[:gemfile]).write

remove_file 'public/index.html'

