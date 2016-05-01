require 'rspec'
require_relative '../src/prototype'

describe 'In a prototype' do

  before do
    @guerrero = PrototypedObject.new
    @guerrero.set_property(:energia, 100)
    @guerrero.set_property(:potencial_defensivo, 10)
    @guerrero.set_property(:potencial_ofensivo, 30)
  end


  it 'should create getter' do
    expect(@guerrero.energia).to eq(100)
    expect(@guerrero.potencial_defensivo).to eq(10)
    expect(@guerrero.potencial_ofensivo).to eq(30)

  end

  it 'should understand property method if set as guerrero s prototype' do
    otro_guerrero = PrototypedObject.new
    otro_guerrero.set_prototype @guerrero
    otro_guerrero.energia = 90
    expect(otro_guerrero.energia).to eq(90)
  end

  it 'should set method' do
  ## suponemos que ya la tiene seteada a la energia
  @guerrero.set_method(:recibe_danio, proc { |pot| @energia = @energia - pot })

  @guerrero.set_method(:atacar_a,
                       proc {
                           |otro_guerrero|
                         if otro_guerrero.potencial_defensivo < self.potencial_ofensivo
                           otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                         end
                       })

  espadachin = PrototypedObject.new
  espadachin.set_prototype(@guerrero)
  espadachin.set_property(:habilidad, 0.5)
  espadachin.set_property(:potencial_espada, 30)
  espadachin.energia= 100
  ## esto no estaba en el enunciado, pero teniendo en cuenta que  el prototype no deberia heredar estado
  ## en algun lugar hay que setearle el potencial ofensivo. no deberia tomarlo de @guerrero.
  espadachin.potencial_ofensivo = 20

  otro_guerrero = @guerrero.clone

    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)

end
end