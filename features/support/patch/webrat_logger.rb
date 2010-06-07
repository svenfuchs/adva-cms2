Webrat::Logging.class_eval do
  def logger
    case Webrat.configuration.mode
    when :rails
      defined?(Rails) ? Rails.logger : nil
    else
      super
    end
  end
end