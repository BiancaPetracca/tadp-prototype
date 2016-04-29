require 'rspec'
require_relative '../src/prototype'

describe 'for all prototyped' do

  before do
    @prototype = PrototypedObject.new
    @prototype.set_property :energia, 100
    @prototype.set_method :get_2energia, proc {self.energia*2}
    @prototyped = PrototypedObject.new
    @prototyped.set_prototype @prototype
  end

  it 'should find them' do
    expect(@prototyped.prototype).to eq @prototype
  end

  it 'should respond to prototype' do
    expect(@prototyped.respond_to? :prototype).to be true
  end

  it 'should get its prototyped' do
    expect(@prototype.prototyped_from_me).to include @prototyped
  end

  it 'should set property everywhere' do
    @prototype.set_property :mana, 150
    expect(@prototyped.mana).to eq(150)
  end

  it 'should set property after stting prototype' do
    proto = PrototypedObject.new
    proto.set_prototype(@prototype)
    expect(proto.energia).to eq(100)
  end
end