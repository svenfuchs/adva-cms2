# make route_set generator pass the current segment/param name to to_param
# if arity allows it. so we can use param names in routes and distinguish them
# in the model.

Gem.patching('rails', '3.0.13') do
  require 'action_dispatch/routing/route_set'

  ActionDispatch::Routing::RouteSet::Generator.class_eval do
    def opts
      parameterize = lambda do |name, value|
        if name == :controller
          value
        elsif value.is_a?(Array)
          value.map { |v| Rack::Mount::Utils.escape_uri(to_param(name, v)) }.join('/')
        else
          return nil unless param = to_param(name, value)
          param.split('/').map { |v| Rack::Mount::Utils.escape_uri(v) }.join("/")
        end
      end
      {:parameterize => parameterize}
    end

    def to_param(name, value)
      value.method(:to_param).arity == 0 ? value.to_param : value.to_param(name)
    end
  end
end
