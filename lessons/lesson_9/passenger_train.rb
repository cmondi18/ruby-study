# frozen_string_literal: true

require_relative 'train'

# === PassengerTrain ===
class PassengerTrain < Train
  validate :train_number, :format, NUMBER_FORMAT

  def initialize(train_number)
    super(train_number)
    @type = :passenger
  end
end
