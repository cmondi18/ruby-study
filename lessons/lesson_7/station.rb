require_relative 'data_error'

class Station
  include InstanceCounter

  attr_reader :title, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    @trains = []
    validate!

    @@stations << self
    register_instances
  end

  def valid?
    validate!
    true
  rescue
    false
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

  def each_train(&block)
    @trains.each(&block)
  end

  protected

  def validate!
    raise DataError, 'Title can\'t be nil' if title.nil?
    raise DataError, 'Title should be at least 5 symbols' if title.length < 5
    raise DataError, 'This station already created' if @@stations.find { |station| station.title == title }
  end
end
