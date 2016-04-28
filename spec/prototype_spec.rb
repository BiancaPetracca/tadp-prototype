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

## suponemos que ya la tiene seteada a la energia
    guerrero.set_method(:recibe_danio, proc { |pot| @energia= @energia - pot })

    guerrero.set_method(:atacar_a,
                        proc {
                            |otro_guerrero|
                          if otro_guerrero.potencial_defensivo < self.potencial_ofensivo
                            otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                          end
                        })

    otro_guerrero = guerrero.clone

# guerrero.atacar_a otro_guerrero
#  expect(otro_guerrero.energia).to eq(80)
    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100

    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)

  end
end

describe 'asdas' do
it 'asdsa' do
  guerrero = PrototypedObject.new
  guerrero.set_property(:energia, 100)
  g2 = PrototypedObject.new
  g2.set_prototype(guerrero)
end
end

=begin
describe 'when cloning' do
  it 'should update methods for all clones' do
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)
  end
end
=end
