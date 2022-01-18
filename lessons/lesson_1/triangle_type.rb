puts 'What is the first side of the triangle?'
first_side = gets.chomp.to_f
puts 'What is the second side of the triangle?'
second_side = gets.chomp.to_f
puts 'What is the third side of the triangle?'
third_side = gets.chomp.to_f
all_sides = [first_side, second_side, third_side].sort # To find hypotenuse and legs

if all_sides.uniq.length == 2
  puts 'Your triangle is isosceles'
elsif all_sides.uniq.length == 1
  puts 'Your triangle is equilateral and isosceles'
elsif all_sides[0]**2 + all_sides[1]**2 == all_sides[2]**2
  puts 'Your triangle is rectangular'
else
  puts 'Your triangle is NOT rectangular, equilateral or isosceles'
end
