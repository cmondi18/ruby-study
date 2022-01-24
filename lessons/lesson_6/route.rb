class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(from_station, to_station)
    @stations = [from_station, to_station]
    validate!

    register_instances
  end

  def validated?
    validate!
    true
  rescue
    false
  end

  def add_intermediate_station(station)
    @stations.insert(-2, station)
  end

  def delete_intermediate_station(station)
    allowed_stations = @stations.slice(1..-1)
    @stations.delete(station) if allowed_stations.include?(station)
  end

  def validate!
    raise 'Station can\'t be nil' if @stations.include?(nil)
  end
end
