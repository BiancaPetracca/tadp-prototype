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


  it 'should create a method' do

    @guerrero.set_method(:recibe_danio, proc { |pot| @energia= @energia - pot })
    @guerrero.set_method(:atacar_a,
                         proc {
                             |otro_guerrero| otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                           if otro_guerrero.potencial_defensivo < self.potencial_ofensivo

                           end
                         })

    otro_guerrero = @guerrero.clone

    @guerrero.atacar_a otro_guerrero
    expect(otro_guerrero.energia).to eq(80)
  end

  it 'should set all methods' do
    @guerrero.set_method(:recibe_danio, proc { |pot| @energia= @energia - pot })
    @guerrero.set_method(:atacar_a,
                         proc {
                             |otro_guerrero| otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
                           if otro_guerrero.potencial_defensivo < self.potencial_ofensivo

                           end
                         })

    otro_guerrero = @guerrero.clone


    espadachin = PrototypedObject.new

    espadachin.set_prototype(@guerrero)

    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)

    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })


  espadachin.atacar_a(otro_guerrero)
  # otro_guerrero.recibe_danio((espadachin.potencial_ofensivo - otro_guerrero.potencial_defensivo))

   # expect(otro_guerrero.potencial_defensivo).to eq(10)
  #expect(otro_guerrero.energia).to eq(65)
   expect(otro_guerrero.instance_variable_get(:@energia)).to eq(65)


  end

  it 'afecta a sus prototypes' do
    espadachin = PrototypedObject.new
    espadachin.set_prototype(@guerrero)

    @guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    expect(@guerrero.prototyped_from_me.size).to eq(1)
  #  espadachin.sanar
 #   expect(espadachin.energia).to eq(110)
  end

  it 'funciona' do
    @guerrero.set_method(:recibe_danio, proc { |pot| @energia= @energia - pot })
    otro_guerrero = @guerrero.clone
    otro_guerrero.recibe_danio(2)
    expect(otro_guerrero.energia).to eq(98)
  end


end