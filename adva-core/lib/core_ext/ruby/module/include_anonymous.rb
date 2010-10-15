# Include an anonymous module
#
# Useful for defining a class or module with a base module. So, instead of:
#
#   class Foo
#     module Base
#       def bar
#         # ...
#       end
#     end
#     include Base
#   end
#
# You can do:
#
#   class Foo
#     include do
#       def bar
#         # ...
#       end
#     end
#   end

Class.class_eval do
  def include(*args, &block)
    block_given? ? super(Module.new(&block)) : super(*args)
  end
end

Module.class_eval do
  def include_with_anonymous(*args, &block)
    block_given? ? include_without_anonymous(Module.new(&block)) : include_without_anonymous(*args)
  end
  alias :include_without_anonymous :include
  alias :include :include_with_anonymous
end
