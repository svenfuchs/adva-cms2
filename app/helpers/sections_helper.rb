module SectionsHelper
  def section_types_for_select
    Section.types.map do |type|
      [t(:"section.types.#{type.demodulize.underscore}"), type]
    end
  end
end