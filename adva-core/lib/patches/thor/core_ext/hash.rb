require 'thor/core_ext/hash_with_indifferent_access'

Thor::CoreExt::HashWithIndifferentAccess.class_eval do
  def to_hash
    Hash.new.merge(self)
  end
end