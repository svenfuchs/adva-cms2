module Adva::Admin::BaseHelper
  def section_types_for_select
    Adva::Section.types.map do |type|
      [t(:"section.types.#{type.demodulize.underscore}"), type]
    end
  end
end