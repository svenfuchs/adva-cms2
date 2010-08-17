require 'rubygems'
require 'watchr'

all = lambda { |m| puts; system "ruby adva-cnet/test/all.rb" }

watch '^adva-cnet/lib/(.*).rb',  &all
watch '^adva-cnet/test/(.*).rb', &all

Signal.trap('QUIT', &all)
Signal.trap('INT') { abort("\n") }