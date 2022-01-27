# frozen_string_literal: true

require_relative 'train'

# === CargoTrain ===
class CargoTrain < Train
  def initialize(train_number)
    super(train_number)
    @type = :cargo
  end
end
