# from lib/core/facets/kernel/silence.rb
def silence_stream(*streams)
  on_hold = streams.collect{ |stream| stream.dup }
  streams.each do |stream|
    stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
    stream.sync = true
  end
  yield
ensure
  streams.each_with_index do |stream, i|
    stream.reopen(on_hold[i])
  end
end

def silence_stdout
  silence_stream(STDOUT) { yield }
end