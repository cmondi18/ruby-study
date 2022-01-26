require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(volume)
    super(volume)
    @type = :cargo
  end

  def take_space(cargo_volume)
    if @space < cargo_volume
      puts 'Sorry, we don\'t have enough place for this cargo'
    else
      super(cargo_volume)
    end
  end
end
