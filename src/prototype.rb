module Prototype
  def set_property(symbol, value)
    set_property_in_place self, symbol, value
    prototyped_from_me.each do |place| set_property_in_place place, symbol, value end
  end

  def set_property_in_place(where, symbol, value)
  where.singleton_class.send :attr_accessor, symbol
  where.send "#{symbol}=", value
  end

  def set_method(symbol, behavior)
    ## converting proc to block again
    define_singleton_method symbol, &behavior
    prototyped_from_me.each do |a_prototyped| a_prototyped.define_singleton_method symbol, &behavior end
  end

  def prototyped_from_me
    Object.constants.select do |a_prototyped| search_prototyped a_prototyped end
  end

  ## es como un clone pero tuneado (?)
  def set_prototype(a_proto)
    @its_prototype = a_proto
  end

  
  def search_prototyped(some_object)
    some_object.respond_to?(:its_prototype=) and @its_prototype.eql? self
  end

end

class PrototypedObject
  include Prototype
  # every prototypedObject knows who is its prototype.
  attr_accessor :its_prototype

  end
