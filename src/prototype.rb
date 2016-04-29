module Prototype
  # sets that property in this prototype and in all its prototyped objects
  def set_property(symbol, value)
    prototyped_from_me.unshift(self).each do |place|
      _set_property_ place, symbol, value
    end
  end

  def _set_property_(where, symbol, value)
    where.singleton_class.send :attr_accessor, symbol
    where.send "#{symbol}=", value
  end

  # sets that method in all prototyped objects from this prototype, and in it too
  def set_method(symbol, behavior)
    prototyped_from_me.unshift(self).each do |a_prototyped|
      a_prototyped.define_singleton_method symbol, &behavior
    end
  end

  # gets every instance who has it as a prototype
  def prototyped_from_me
    ObjectSpace.each_object(PrototypedObject).to_a.select do |a_prototyped|
      is_it_mine? a_prototyped
    end
  end

  # defines all its prototype's methods
  def set_prototype(a_proto)
    self.prototype = a_proto
    self.prototype.singleton_methods.each do |a_method|
      set_method(a_method, prototype.method(a_method).to_proc)
    end
    self.prototype.instance_variables.each do |a_variable|
      self.set_property(instance_variable_sym(a_variable), (self.prototype.instance_variable_get a_variable))
    end
  end

  def instance_variable_sym(v)
    v.slice(1, v.length).to_sym
  end

  # is it its prototype?
  def is_it_mine?(a_prototyped)
    a_prototyped.prototype.eql? self
  end

end

class PrototypedObject
  include Prototype
  # every prototypedObject knows who is its prototype.
  attr_accessor :prototype


end
