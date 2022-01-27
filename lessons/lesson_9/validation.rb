# frozen_string_literal: true
require_relative 'data_error'

# === Accessors ===
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  # === ClassMethods ===
  module ClassMethods
    attr_reader :validations

    def validate(name, validation_type, *args)
      @validations ||= []
      @validations << [[name, validation_type, args[0]]]
    end
  end

  # === InstanceMethods ===
  module InstanceMethods
    def validate!
      self.class.validations&.each do |validations_array|
          validations_array.each do |var, type, arg|
            send("#{type}_validate", instance_variable_get("@#{var}"), arg)
          end
        end
    end
  end

  def valid?
    validate!
    true
  rescue DataError
    false
  end

  private

  def presence_validate(name, _)
    raise DataError, "Variable can't be nil or empty " if name.nil? || name == ''
  end

  def format_validate(name, format)
    raise DataError, "#{name} has incorrect format" if name !~ format
  end

  def type_validate(name, type)
    raise DataError, "#{name} has wrong type" if name.downcase.capitalize != type
  end
end
