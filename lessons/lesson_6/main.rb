require_relative 'menu'

menu = Menu.new
begin
  menu.show_menu
rescue RuntimeError => e
  puts '*****'
  puts "Error. #{e.message}"
  puts '*****' # just for output splitting
  retry
end
