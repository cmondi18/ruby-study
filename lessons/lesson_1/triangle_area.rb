puts 'What is base of the triangle?'
base = gets.chomp
puts 'What is height of the triangle?'
height = gets.chomp
triangle_area = 0.5 * base.to_i * height.to_i

puts "Triangle area is #{triangle_area}"
