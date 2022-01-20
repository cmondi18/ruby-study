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
