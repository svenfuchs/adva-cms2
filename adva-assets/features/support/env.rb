require File.expand_path('../../../../adva-core/features/support/env', __FILE__)

files = Dir[File.expand_path('../../../../adva-core/features/{support,step_definitions}/**/*.rb', __FILE__)].sort
files.each { |file| require file }
