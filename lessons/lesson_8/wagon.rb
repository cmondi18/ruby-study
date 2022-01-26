require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_reader :type, :occupied_space

  def initialize(space)
    @space = space
    @occupied_space = 0
  end

  def take_space(amount)
    @occupied_space += amount
  end

  def free_space
    @space - @occupied_space
  end
end
