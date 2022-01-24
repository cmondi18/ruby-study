require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize
    super
    @type = :passenger
  end
end
