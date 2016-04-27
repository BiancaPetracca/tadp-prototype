require 'rspec'
require_relative '../src/prototype'

describe 'In a prototype' do

  it 'should create getter' do

    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    expect(guerrero.energia).to eq(100)
    expect(guerrero.potencial_defensivo).to eq(10)
    expect(guerrero.potencial_ofensivo).to eq(30)

  end

  it 'should create a method' do
    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)

## suponemos que ya la tiene seteada
    guerrero.set_method(:recibe_danio, proc {|pot| @energia=  @energia - pot})

    guerrero.set_method(:atacar_a,
                        proc {
                            |otro_guerrero|
                          if otro_guerrero.potencial_defensivo < self.potencial_ofensivo
                            otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                          end
                        })

    otro_guerrero = guerrero.clone

    guerrero.atacar_a otro_guerrero
    expect(otro_guerrero.energia).to eq(80)

  end
end

describe 'When defining behavior' do
  it 'should clone' do

  end
end