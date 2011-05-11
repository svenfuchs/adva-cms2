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
  puts response.body
end

