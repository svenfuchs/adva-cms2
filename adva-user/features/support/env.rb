require File.expand_path('../../../../adva-core/features/support/env', __FILE__)

files = Dir[File.expand_path('../../../../adva-core/features/{support,step_definitions}/**/*.rb', __FILE__)]
files.each { |file| require file }