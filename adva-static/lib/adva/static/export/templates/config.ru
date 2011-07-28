# This config.ru file simply serves static files in the format exported by
# adva-static. I.e. you can use it (e.g.) to deploy exported html files to
# Heroku.

class Static < ::Rack::File
  attr_reader :app, :root

  def initialize(app, root)
    @app  = app
    @root = root
  end

  def call(env)
    if get?(env) && path = static(env)
      super(env.merge('PATH_INFO' => path))
    else
      app.call(env)
    end
  end

  protected

    def static(env)
      path = env['PATH_INFO'].chomp('/')
      [path, "#{path}.html", "#{path}/index.html"].detect { |path| file?(path) }
    end

    def file?(path)
      File.file?(File.join(root, ::Rack::Utils.unescape(path)))
    end

    def get?(env)
      env['REQUEST_METHOD'] == 'GET'
    end
end

use Static, ::File.expand_path('..', __FILE__)
run lambda { [404, { 'content-type' => 'text/html' }, '<h1>404 Not found.</h1>'] }
