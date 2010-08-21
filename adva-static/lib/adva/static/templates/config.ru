require 'rubygems'
require 'rack/utils'

class Static < ::Rack::File
  def call(env)
    path = env['PATH_INFO'].chomp('/')
    path = [path, "#{path}.html", "#{path}/index.html"].detect { |path| file?(path) }
    
    if path
      super(env.merge('PATH_INFO' => path))
    else
      [404, { 'Content-Type' => 'text/plain' }, '404']
    end
  end

  protected
  
    def file?(path)
      File.file?(File.join(root, ::Rack::Utils.unescape(path)))
    end
end

run Static.new(File.expand_path(File.dirname(__FILE__)))