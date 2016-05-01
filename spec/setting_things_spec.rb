require 'rspec'
require_relative '../src/prototype'

describe 'When defining things in a prototype' do

  before do
    @proto = PrototypedObject.new
    @proto.set_property(:a_property, 100)
    @proto.set_method(:a_method, proc { "asdasd"})
  end
  it 'should be added to properties' do
    @proto.set_property(:energia, 100)
    expect(@proto.properties.size).to be 4
  end

  it 'should be added to methods' do
    beh = proc { "holass" }
    @proto.set_method(:a_property, beh)
    expect(@proto.methods).to include(:a_property => beh)
  end

  it 'should return a behavior' do
    expect(@proto.properties.select do |key, value| key.eql? :a_property end).to include(:a_property)
  end

  it 'should return a behavior, of a property' do
    expect(@proto.property_behavior(:a_property)).to be_a(Proc)
  end

  it 'should return a behavior, of a method' do
    expect(@proto.method_behavior(:a_method)).to be_a(Proc)
  end

  it 'should return all defined behaviors for that symbol (everytime it should be only one)' do
    expect(@proto.behavior(:a_method)).to be_a(Proc)
  end

  it 'if i define again, it shouldnt be twice' do
    @proto.set_property(:a_property, 103)
    expect(@proto.behavior(:a_property)).to be_a(Proc)
  end

  it 'executes that block' do
    m = @proto.behavior(:a_method)
    @proto.instance_exec &m
  end
end
