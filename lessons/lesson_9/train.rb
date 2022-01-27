# frozen_string_literal: true

require_relative 'data_error'
require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

# === Train ===
class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessors

  strong_attr_accessor :speed, Integer
  attr_reader :train_number, :wagons, :route, :type
  attr_accessor_with_history :driver

  NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i.freeze

  validate :train_number, :format, NUMBER_FORMAT

  @@trains = []

  def self.find(train_number)
    @@trains.find { |train| train.train_number == train_number }
  end

  def initialize(train_number)
    @train_number = train_number
    @wagons = []
    @speed = 0
    local_validate!
    validate!

    @@trains << self
    register_instances
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon if wagon_compatible?(wagon)
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if @speed.zero?
  end

  def get_route(route)
    @route = route
    route.stations.first.accept_train(self)
    @current_station_index = 0
  end

  def move_to_next_station
    return unless next_station

    current_station.send_train(self)
    next_station.accept_train(self)
    @current_station_index += 1
  end

  def move_to_previous_station
    return unless previous_station

    current_station.send_train(self)
    previous_station.accept_train(self)
    @current_station_index -= 1
  end

  def each_wagon(&block)
    @wagons.each_with_index(&block)
  end

  protected

  def local_validate!
    raise DataError, 'This train already created' if @@trains.find { |train| train.train_number == train_number }
  end

  # this method is used for add_wagon function
  def wagon_compatible?(wagon)
    @type == wagon.type
  end

  # these methods are used for move_to functions so could be protected
  def current_station
    @route.stations[@current_station_index]
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1] unless @current_station_index.zero?
  end
end
