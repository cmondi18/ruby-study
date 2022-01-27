# frozen_string_literal: true

require_relative 'data_error'
require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

# === Station ===
class Station
  include InstanceCounter
  include Validation
  extend Accessors

  TITLE_FORMAT = /^.{6,}$/i.freeze

  validate :title, :presence
  validate :title, :presence, String
  validate :title, :format, TITLE_FORMAT

  attr_reader :title, :trains
  strong_attr_accessor :city, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(title)
    @title = title
    @trains = []
    local_validate!
    validate!

    @@stations << self
    register_instances
  end

  def valid?
    validate!
    true
  rescue DataError
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

  def local_validate!
    raise DataError, 'This station already created' if @@stations.find { |station| station.title == title }
  end
end
