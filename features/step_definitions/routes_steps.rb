Given 'the routes are loaded' do
  @routes = Rails.application.routes
end

Then 'the following routes should be recognized:' do |table|
  table.hashes.each do |options|
    method_and_path  = options.slice('method', 'path')
    expected_options = options.except('method', 'path', 'params')
    expected_options.each { |name, value| expected_options.delete(name) if value.blank? }
    
    options['params'].split(',').each do |param|
      name, value = param.split(':')
      expected_options[name] = value
    end if options['params']
    
    assert_recognizes(expected_options.symbolize_keys, method_and_path.symbolize_keys)
  end
end