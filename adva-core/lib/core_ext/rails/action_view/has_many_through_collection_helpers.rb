require 'action_view/helpers/form_helper'

ActionView::Helpers::FormBuilder.send :include do
  def has_many_through_collection_check_boxes(attribute, collection, label_attribute)
    through_class = object.class.reflect_on_association(attribute).class_name.constantize
    foreign_key = through_class.reflect_on_all_associations(:belongs_to).detect { |r| r.class_name != object.class.name }.primary_key_name

    html = ''
    collection.each_with_index do |item, ix|
      param   = "#{object_name}[#{attribute}_attributes][#{ix}]"
      through = object.send(attribute).detect { |t| t.send(foreign_key) == item.id }

      if through
        html << @template.hidden_field_tag("#{param}[id]", through.id, :id => '')
        html << @template.hidden_field_tag("#{param}[_destroy]", '1', :id => '')
        html << @template.label_tag("#{param}[_destroy]", :class => 'checkbox') do
          @template.check_box_tag("#{param}[_destroy]", '1', true) + item.send(label_attribute)
        end
      else
        html << @template.label_tag("#{param}[#{foreign_key}]", :class => 'checkbox') do
          @template.check_box_tag("#{param}[#{foreign_key}]", item.id) + item.send(label_attribute)
        end
      end
    end
    html.html_safe
  end
end
