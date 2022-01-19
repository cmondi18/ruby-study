class Station
  attr_reader :trains, :title

  def initialize(title)
    @title = title
    @trains = []
  end

  def trains_on_station
    @trains
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def accept_train(train)
    @trains << train
  end

  def send_train(train)
    if @trains.include?(train)
      @trains.delete(train)
    else
      puts "There is not #{train} in this station"
    end
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

  def show_stations
    @stations.each { |station| puts station.title }
  end
end

class Train
  attr_accessor :speed
  attr_reader :wagons_count, :type

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
    if @speed.zero?
      @wagons_count += 1
    else
      puts 'Your speed is not 0'
    end
  end

  def remove_wagon
    if @speed.zero? && @wagons_count != 0
      @wagons_count -= 1
    else
      puts "You can't remove wagon, because you don't have any of them or your speed is not 0"
    end
  end

  def get_route(route)
    @route = route
    route.stations.first.accept_train(self)
    @current_station_index = 0
  end

  def route?
    if @route.nil?
      puts "You don't have any routes"
      false
    else
      true
    end
  end

  def current_station
    @route.stations[@current_station_index] if route?
  end

  def next_station
    if route?
      if @route.stations[@current_station_index + 1].nil?
        puts "You already on the finishing point and don't have next station"
      else
        @route.stations[@current_station_index + 1]
      end
    end
  end

  def previous_station
    if route?
      if @current_station_index.zero?
        puts "You at starting point and don't have previous station"
      else
        @route.stations[@current_station_index - 1]
      end
    end
  end

  def move_to_next_station
    if route?
      if @route.stations[@current_station_index + 1].nil?
        puts "You already on the finishing point and can't move to the next station"
      else
        current_station.send_train(self)
        next_station.accept_train(self)
        @current_station_index += 1
      end
    end
  end

  def move_to_previous_station
    if route?
      if @current_station_index.zero?
        puts "You at starting point and can't move to the previous station"
      else
        current_station.send_train(self)
        previous_station.accept_train(self)
        @current_station_index -= 1
      end
    end
  end
end
