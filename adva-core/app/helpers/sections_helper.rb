module SectionsHelper
  def section_types_option_values
    Section.types.map do |type|
      [t(:"section.types.#{type.demodulize.underscore}"), type]
    end
  end
end