require_dependency 'section'

Section.class_eval do
  # TODO unfortunate, but not defining this on Section and subclasses breaks because
  # class_inheritable_attributes get out of sync and crash. this will probably change
  # once we are able to load code slices lazily
  (descendants << self).each do |klass|
    klass.has_many :categories, :foreign_key => :section_id
    klass.accepts_nested_attributes_for :categories
  end
end
