require 'active_record'

module Attributes
  autoload :ActMacro,        'attributes/act_macro'
  autoload :Key,             'attributes/key'
  autoload :Value,           'attributes/value'
  autoload :InstanceMethods, 'attributes/instance_methods'
end

ActiveRecord::Base.extend(Attributes::ActMacro)
