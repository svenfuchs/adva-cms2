# For date column cells named created_on, updated_at etc. this transforms the
# corresponding cell's value to a datetime in the current time zone (i.e. this
# works for both normal tables and row_hash tables):
Transform /^table:/ do |table|
  timezonify = lambda do |table|
    dates = table.headers.select { |header| header =~ /(_at|_on)$/ }
    dates.each { |date| table.map_column!(date) { |date| DateTime.parse(date).in_time_zone } }
    table.transpose
  end
  timezonify.call(timezonify.call(table))
end