module FormHelper
  def fieldset(&block)
    content_tag(:fieldset, &block)
  end

  def column(&block)
    content_tag(:div, :class => 'column', &block)
  end

  def buttons(&block)
    content_tag(:p, :class => 'buttons', &block)
  end
end