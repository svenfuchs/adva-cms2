module TestHelper
  module MinimalTemplate
    attr_accessor :view_path

    def view
      @view ||= ActionView::Base.new(view_path).tap do |view|
        view.output_buffer = ActiveSupport::SafeBuffer.new rescue ''
      end
    end
  end
end
