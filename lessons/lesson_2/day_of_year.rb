months = { january: 31,
           february: 28,
           march: 31,
           april: 30,
           may: 31,
           june: 30,
           july: 31,
           august: 31,
           september: 30,
           october: 31,
           november: 30,
           december: 31
}

puts 'Print year'
user_year = gets.chomp.to_i

puts 'Print month'
user_month = gets.chomp.downcase.to_sym
unless months.include?(user_month)
  puts 'You printed wrong month'
  exit
end

puts 'Print day'
user_day = gets.chomp.to_i
if user_day > months[user_month]
  puts 'You printed more days that can be in this month'
  exit
end

months[:february] = 29 if (user_year % 4).zero? && (user_year % 100).zero? && (user_year % 400).zero?


day_of_year = 0
months.each do |month, days|
  if month == user_month
    day_of_year += user_day
    break
  else
    day_of_year += days
  end
end

puts "Your day serial number is #{day_of_year} from the 1 January of the #{user_year} year"
