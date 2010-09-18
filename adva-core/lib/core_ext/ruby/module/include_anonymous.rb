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