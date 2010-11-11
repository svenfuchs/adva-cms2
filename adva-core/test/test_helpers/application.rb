module TestHelper
  module Application
    def self.included(base)
      base.send(:attr_reader, :routes, :controller)
    end

    def teardown
      @routes = nil
      @controller = nil
      Rails.application = nil
      super
    end

    def setup_application(&block)
      Rails.application = Rails::Application.send(:new)
      Rails.application.singleton_class.send(:include, Rails::Application::Configurable)
      # devise probably should use some defaults instead
      Devise.warden_config = Rails.application.config

      if block_given?
        @routes ||= ActionDispatch::Routing::RouteSet.new.tap do |routes|
          routes.draw(&block)
          ActionController::Base.send(:include, routes.url_helpers)
        end
      end
    end

    def setup_controller(type, &block)
      @controller = "#{type.to_s.camelize}Controller".constantize.new.tap do |controller|
        controller.request  = ActionDispatch::TestRequest.new
        controller.response = ActionDispatch::TestResponse.new
        controller.params = { :action => 'show' }
        yield(controller) if block_given?
      end
    end

    def process_action_rendering(action, params, &block)
      controller.singleton_class.send(:define_method, :render_to_string) { |*| instance_eval(&block) } if block_given?
      controller.params.merge!(params.reverse_merge(:action => action))
      controller.process(action)
    end
  end
end
