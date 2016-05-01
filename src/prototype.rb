module Prototype
  attr_accessor :methods, :properties

  def set_property(symbol, value)
    # defining accessors in prototype
    singleton_class.send :attr_accessor, symbol
    send "#{symbol}=", value
    # finding instance variables with that name
    var = instance_variables.select do |var|
      var.to_s.eql? "@#{symbol}"
    end
    # storing getter
    methods.store "#{symbol}=".to_sym, proc { |val| self.instance_variable_set var[0], val }
    # storing setter
    methods.store "#{symbol}".to_sym, proc { self.instance_variable_get var[0] }

  end

  def set_method(symbol, behavior)
    # storing defined method
    methods.store symbol, behavior
    self.define_singleton_method symbol, &behavior
  end

  def set_prototype(a_proto)
    @its_prototype = a_proto
  end

  def behavior(symbol)
    method = methods.select do |key, value|
      key.eql? symbol
    end
    method.fetch symbol
  end


  def initialize
    @methods = {}
  end

end

class PrototypedObject
  include Prototype
  attr_accessor :its_prototype

  def method_missing(symbol, *args)
    throw NoMethodError unless its_prototype.respond_to? symbol
    instance_exec *args, &(its_prototype.behavior symbol)
  end
end