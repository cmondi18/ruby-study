puts 'What is the first argument (a)?'
a = gets.chomp.to_f

if a.zero?
  puts 'first argument can\'t be zero, try again'
  exit
end

puts 'What is the second argument (b)?'
b = gets.chomp.to_f
puts 'What is the third argument (c)?'
c = gets.chomp.to_f

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
