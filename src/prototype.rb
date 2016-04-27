module Prototype
  def set_property(symbol, value)
    singleton_class.send :attr_accessor, symbol
    send "#{symbol}=", value
  end

  def set_method(symbol, behavior)
    ## converting proc to block again
    define_singleton_method symbol, &behavior
  end
end

class PrototypedObject
  include Prototype

end