module Prototype
  def set_property(symbol, value)
    self.singleton_class.send :attr_accessor, symbol
    self.send "#{symbol}=", value
  end

  def set_method(symbol, behavior)
    ## converting proc to block again
    self.define_singleton_method symbol, &behavior
  end

  ## es como un clone pero tuneado (?)
  def set_prototype(a_proto)
    @its_prototype = a_proto
  end

  def get_lambda_method(symbol)
    self.method(symbol).to_proc
  end
end

class PrototypedObject
  include Prototype
  # every prototypedObject knows who is its prototype.
  attr_accessor :its_prototype


  def method_missing(symbol, *args)
    throw NoMethodError unless @its_prototype.respond_to? symbol
    method = @its_prototype.get_lambda_method symbol
    self.instance_eval &method if @its_prototype.method(symbol).arity.eql? 0
    self.instance_exec args, &method

  end
end
