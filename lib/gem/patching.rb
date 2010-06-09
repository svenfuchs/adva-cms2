module Gem
  def self.patching(gem_name, target_version, &block)
    if spec = Gem.loaded_specs[gem_name]
      active_version = spec.version.to_s
      if active_version != target_version
        raise "PATCH targeting version #{target_version} of #{gem_name} but active version is #{active_version}"
      else
        yield
      end
    end
  end
end
