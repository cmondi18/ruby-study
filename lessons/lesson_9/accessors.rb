# frozen_string_literal: true
require_relative 'data_error'

# === Accessors ===
module Accessors

  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        @history ||= {}
        @history[var_name] ||= []
        @history[var_name] = @history[var_name] << value
      end
      define_method("#{name}_history") do
        @history ||= {}
        @history[var_name]
      end
    end
  end

  def strong_attr_accessor(name, klass)
    var_name = "@#{name}".to_sym
    define_method("@#{name}".to_sym) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise DataError, "Error. Class of the value should be #{klass}" unless value.class.is_a?(klass)

      instance_variable_set(var_name, value)
    end
  end
end
