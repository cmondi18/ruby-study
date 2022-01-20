class Station
  attr_reader :trains

  def initialize(title)
    @title = title
    @trains = []
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def accept_train(train)
    @trains << train unless @trains.include?(train)
  end

  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end
end

class Route
  attr_reader :stations

  def initialize(from_station, to_station)
    @stations = [from_station, to_station]
  end

  def add_intermediate_station(station)
    @stations.insert(-2, station)
  end

  def delete_intermediate_station(station)
    allowed_stations = @stations.slice(1..-1)
    @stations.delete(station) if allowed_stations.include?(station)
  end
end

class Train
  attr_accessor :speed
  attr_reader :wagons_count

  def initialize(train_number, type, wagons_count)
    @train_number = train_number
    @type = type
    @wagons_count = wagons_count
    @speed = 0
  end

  def stop
    @speed = 0
  end

  def add_wagon
    @wagons_count += 1 if @speed.zero?
  end

  def remove_wagon
    @wagons_count -= 1 if @speed.zero? && @wagons_count != 0
  end

  def get_route(route)
    @route = route
    route.stations.first.accept_train(self)
    @current_station_index = 0
  end

  def current_station
    @route.stations[@current_station_index]
  end

  def next_station
    @route.stations[@current_station_index + 1]
  end

  def previous_station
    @route.stations[@current_station_index - 1] unless @current_station_index.zero?
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
end
