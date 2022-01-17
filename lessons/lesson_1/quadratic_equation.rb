puts 'What is the argument?'
a = gets.chomp
puts 'What is the second argument?'
b = gets.chomp
puts 'What is the third argument?'
c = gets.chomp

d = b**2 - 4 * a * c

if d.positive?
  d_root = Math.sqrt(d)
  x1 = (-b + d_root) / (2 * a)
  x2 = (-b - d_root) / (2 * a)
  puts "Discriminant is #{d_root}, roots are #{x1} and #{x2}"
elsif d.zero?
  x = -b / (2 * a)
  puts "Discriminant is #{d}, root is #{x}"
else
  puts 'There are no roots'
end
