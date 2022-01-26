# frozen_string_literal: true

require_relative 'data_error'
require_relative 'menu'

menu = Menu.new
menu.seed
begin
  menu.show_menu
rescue DataError => e
  puts '*****'
  puts "Error. #{e.message}"
  puts '*****' # just for output splitting
  retry
end
