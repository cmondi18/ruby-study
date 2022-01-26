require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(seats)
    super(seats)
    @type = :passenger
  end

  def take_space
    if @space == @occupied_space
      puts 'Sorry, all places are occupied'
    else
      super(1)
    end
  end
end
