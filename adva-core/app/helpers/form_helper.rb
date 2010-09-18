module FormHelper
  def fieldset(&block)
    content_tag(:fieldset, &block)
  end

  def column(&block)
    content_tag(:div, :class => 'column', &block)
  end

  def button_group(&block)
    content_tag(:div, :class => 'buttons', &block)
  end
end