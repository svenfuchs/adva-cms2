# For date column cells named created_on, updated_at etc. this transforms the
# corresponding cell's value to a datetime in the current time zone (i.e. this
# works for both normal tables and row_hash tables):
timezonify = lambda do |table|
  dates = table.headers.select { |header| header =~ /(_at|_on)$/ }
  dates.each { |date| table.map_column!(date) { |date| DateTime.parse(date).in_time_zone } }
  table.transpose
end

objectify = lambda do |table|
  types = Section.types.map(&:underscore) << 'section' << 'site'
  sections = table.headers.select { |header| types.include?(header) }
  sections.each { |key| table.map_column!(key) { |value| key.gsub('_id', '').classify.constantize.find_by_name(value) } }
  table.transpose
end

TRANSFORM_FOREIGN_KEY_TYPES = Section.types.map(&:underscore) << 'section' << 'site'
TRANSFORM_FOREIGN_KEY_MAP = {}

foreign_keyify = lambda do |table|
  keys = TRANSFORM_FOREIGN_KEY_TYPES.map { |type| "#{type}_id" }
  keys = table.headers.select { |header| keys.include?(header) }
  keys.each do |key|
    table.map_column!(key) do |value|
      klass = TRANSFORM_FOREIGN_KEY_MAP[key] || key.gsub('_id', '').classify.constantize
      Array(klass.find_by_name(value)).first.try(:id).to_s
    end
  end
  table.transpose
end

# FIXME must be here because one apparently can't register multiple transforms for the
# same regex (like /^table:/) in cucumber. should really be in adva-categories though.
categoryify = lambda do |table|
  if table.headers.include?('categories')
    table.map_column!('categories') do |categories|
      names = categories.split(',').map(&:strip)
      Category.where(:name => names).all
    end
  end
  table.transpose
end

Transform /^table:/ do |table|
  table = timezonify.call(timezonify.call(table))
  table = objectify.call(objectify.call(table))
  table = foreign_keyify.call(foreign_keyify.call(table))
  table = categoryify.call(categoryify.call(table))
  table
end
