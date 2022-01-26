# frozen_string_literal: true

require_relative 'train'

# === PassengerTrain ===
class PassengerTrain < Train
  def initialize(train_number)
    super(train_number)
    @type = :passenger
  end
end
