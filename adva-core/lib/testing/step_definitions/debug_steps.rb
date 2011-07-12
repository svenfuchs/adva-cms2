Then 'what' do
  out = "\n\n\n" +
    "#{@request.method} #{@request.env["SERVER_NAME"]}#{@request.env["REQUEST_URI"]}\n" +
    "params: #{@request.parameters.inspect}\n\n" +
    response.body +
    "\n\n\n"
  puts out.gsub("\n", "\n  ")
end

Then 'debug' do
  debugger
  true
end

Then /^(?:|I )output the page$/ do
  puts page.body
end

When /^I pause$/ do
  STDERR.puts "pausing - press enter to continue"
  STDIN.gets
end

Then /^dump the table "([^"]*)"$/ do |table_name|
  filename   = Rails.root.join('tmp').join("dump-#{table_name}.csv").expand_path
  sql        = "COPY #{table_name} TO '#{filename}' WITH CSV HEADER"

  ActiveRecord::Base.connection.execute sql
end
