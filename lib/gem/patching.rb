module Gem
  def self.patching(gem_name, targeted_gem_version, &block)
    active_gem_version = Gem.loaded_specs[gem_name].version.to_s
    if active_gem_version != targeted_gem_version
      raise "PATCH targeting version #{targeted_gem_version} of #{gem_name} but active version is #{active_gem_version}"
    else
      yield
    end
  end
end
