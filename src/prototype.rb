module Prototype
  attr_accessor :methods, :properties

  def set_property(symbol, value)
    # defining accessors in prototype
    self.singleton_class.send :attr_accessor, symbol
    self.send "#{symbol}=", value
    var = self.instance_variables.select do |var| var.to_s.eql? "@#{symbol}" end
    var = var[0]
    # getter
    properties.store "#{symbol}=".to_sym, proc {|val| self.instance_variable_set(var, val)}
    # setter
    properties.store "#{symbol}".to_sym, proc {self.instance_variable_get(var)}

  end

  def set_method(symbol, behavior)
    # method with its behavior
    methods.store symbol, behavior
    self.define_singleton_method symbol, &behavior
  end

  def set_prototype(a_proto)
   @its_prototype = a_proto
  end

  def method_behavior(symbol)
    method = methods.select do |key, value| key.eql? symbol end
    method.fetch(symbol) unless method.empty?
  end

  def property_behavior(symbol)
    property = properties.select do |key, value| key.eql? symbol end
    property.fetch(symbol) unless property.empty?
  end

  def behavior(symbol)
    method_behavior(symbol) || property_behavior(symbol)
  end


  def initialize
    @methods = {}
    @properties = {}
  end

end

class PrototypedObject
  include Prototype
  # every prototypedObject knows who is its prototype.
  attr_accessor :its_prototype

  def method_missing(symbol, *args)
    throw NoMethodError unless self.its_prototype.respond_to? symbol
  #  beh = self.its_prototype.behavior symbol
   # all_args = args
    self.instance_exec *args, &(self.its_prototype.behavior symbol)
  end
end