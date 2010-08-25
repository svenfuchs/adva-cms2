# require File.expand_path('../../test_helper', __FILE__)
#
# require 'fileutils'
# require 'rack/cache'
# require 'rack/cache/options'
# require 'rack/cache/request'
# require 'rack/cache/response'
# require 'rack/cache/storage'
#
# Rack::Cache::EntityStore::Disk::Body.class_eval do
#   def join
#     ''.tap { |result| each { |string| result << string } }
#   end
# end
#
# class MetaStore < Rack::Cache::MetaStore::Disk
#   def store(request, response, entity_store)
#     key = cache_key(request)
#     stored_env = persist_request(request)
#
#     # write the response body to the entity store if this is the
#     # original response.
#     if response.headers['X-Content-Digest'].nil?
#       digest, size = entity_store.write(key, response.body)
#       response.headers['X-Content-Digest'] = digest
#       response.headers['Content-Length'] = size.to_s unless response.headers['Transfer-Encoding']
#       response.body = entity_store.open(digest)
#     end
#
#     # read existing cache entries, remove non-varying, and add this one to
#     # the list
#     vary = response.vary
#     entries =
#       read(key).reject do |env,res|
#         (vary == res['Vary']) &&
#           requests_match?(vary, env, stored_env)
#       end
#
#     headers = persist_response(response)
#     headers.delete 'Age'
#
#     entries.unshift [stored_env, headers]
#     write key, entries
#     key
#   end
# end
#
# class EntityStore < Rack::Cache::EntityStore::Disk
#   def write(key, body)
#     path = storage_path(key)
#
#     tmp = Tempfile.new(key.gsub('/', '-'))
#     body.each { |part| tmp.write(part) }
#     tmp.close
#
#     FileUtils.mkdir_p(File.dirname(path), :mode => 0755)
#     FileUtils.mv(tmp.path, path)
#
#     [key, File.size(path)]
#   end
#
#   def body_path(key)
#     storage_path(key)
#   end
#
#   def storage_path(key)
#     path = key.sub(%r(^https?://[^/]+/), '').chomp('?')
#     path = "#{path}.html" if File.extname(path).empty?
#     File.join(root, path)
#   end
# end
#
# module AdvaStatic
#   class RackCacheTest < Test::Unit::TestCase
#     attr_reader :meta_store, :entity_store
#
#     def setup
#       Site.create(
#         :host => 'localhost:3000',
#         :title => 'Site Title',
#         :name => 'Site Name',
#         :sections_attributes => [{ :title => 'Home' }]
#       )
#
#       @meta_store   = MetaStore.new("#{tmp_dir}/meta")
#       @entity_store = EntityStore.new("#{tmp_dir}/export")
#     end
#
#     def teardown
#       FileUtils.rm_r(tmp_dir)
#     end
#
#     test "caches a file" do
#       request  = request('/test')
#       response = response(200, headers, 'body')
#
#       assert_equal 'http://example.org/test?', meta_store.store(request, response, entity_store)
#       assert_equal 'body', meta_store.lookup(request, entity_store).body.join
#       assert tmp_dir.join('export/test.html').file?
#     end
#
#     test "does not cache a redirect" do
#       request  = request('/test')
#       response = response(301, {}, 'body')
#
#       assert_equal 'http://example.org/test?', meta_store.store(request, response, entity_store)
#       assert !tmp_dir.join('export/test.html').file?
#     end
#
#     protected
#
#       def headers
#         { 'Cache-Control' => 'max-age=420' } # , 'rack-cache.cache_key' => FooKey
#       end
#
#       def tmp_dir
#         Pathname.new('/tmp/adva-static/rack-cache').tap { |path| FileUtils.mkdir_p(path) }
#       end
#
#       def env_for(uri, options = nil)
#         Rack::MockRequest.env_for(uri, headers.merge(options || {}))
#       end
#
#       def request(uri, options = nil)
#         Rack::Cache::Request.new(env_for(uri, options))
#       end
#
#       def response(status, headers, body)
#         Rack::Cache::Response.new(status, headers || {}, Array(body).compact)
#       end
#
#       def path(path)
#         Adva::Static::Path.new(path)
#       end
#   end
# end